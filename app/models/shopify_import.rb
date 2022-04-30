# frozen_string_literal: true

class ShopifyImport < ApplicationRecord
  PLATFORM = Platform.find_by(name: 'Shopify').id

  class << self
    def start_importer(app_id, api, time, data_set, cursor = '')
      ImportLog.create!({ platform_id: time[:start], app_id: app_id, start_time: DateTime.now, status: 0 })

      run_data(app_id, api, time, data_set, cursor)
    end

    def run_data(app_id, api, time, data_set, cursor = '')
      data = pick_importer(api, data_set, time, cursor)

      return Rollbar.error("No data received from Shopify: #{data}", data) unless data.present?

      data = JSON.parse(data)

      records = OpenStruct.new data['data']

      return Rollbar.error("Data.data is nil: #{records}", records) unless records.present?

      process(app_id, api, time, records, data_set, cursor) if records.present?
    end

    def pick_importer(api, data_set, time, cursor)
      if data_set == 'user'
        data_importer(api, ShopifyUser.gql_data(api, time, cursor))
      else
        data_importer(api, ShopifyPayment.gql_data(time, cursor))
      end
    end

    def data_importer(api, body)
      path = "https://partners.shopify.com/#{api.partner_id}/api/2021-10/graphql.json"
      header = {
        'Content-Type': 'application/graphql',
        'X-Shopify-Access-Token': api.api_key
      }
      data = Faraday.post(path, body, header).body
    end

    def process(app_id, api, time, records, data_set, cursor)

      return Rollbar.error("No app or transaction data received: #{records}", records) unless records['app'].present? || records['transactions'].present?

      results = if data_set == 'user'
                  records['app']['events']
                else
                  records['transactions']
                end

      return Rollbar.error("App events or transactions not found: #{results}", results) unless results.present? && results.size.positive?

      edges = results['edges']

      if data_set.include? 'test'
        edges.group_by { |e| e['node']['app']['name'] }
      else
        final_data_set = if data_set == 'user'
                           ShopifyUser.process_data(edges, app_id, time[:end], PLATFORM, cursor)
                         else
                           grouped = edges.filter { |e| e['node']['app']['name'] == App.find(app_id).app_name }
                           ShopifyPayment.process_data(grouped, app_id, time[:end], PLATFORM, cursor, data_set)
                         end

        if results['pageInfo']['hasNextPage']
          run_data(app_id, api, time, data_set,
                   edges.last['cursor'])
        else
          ImportLog.where(platform_id: PLATFORM, app_id: app_id).update_all({ status: 1, end_time: DateTime.now })
        end

        ExternalMetric.where(app_id: app_id, platform_id: PLATFORM, date: time[:end].to_date.strftime('%d-%m-%Y'))
      end
    end
  end
end
