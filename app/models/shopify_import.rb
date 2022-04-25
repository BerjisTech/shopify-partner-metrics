# frozen_string_literal: true

class ShopifyImport < ApplicationRecord
  PLATFORM = Platform.find_by(name: 'Shopify').id

  class << self
    def start_importer(app_id, api, time, data_set, cursor = '')
      data = pick_importer(api, data_set, time, cursor)

      # process_data(data, app_id, time)
      records = OpenStruct.new data.data

      process(app_id, api, time, records, data_set, cursor)
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
      data = OpenStruct.new JSON.parse(Faraday.post(path, body, header).body)
    end

    def process(app_id, api, time, records, data_set, cursor)
      results = if data_set == 'user'
                  records.app['events']
                else
                  records.transactions
                end
      edges = results['edges']

      if data_set.include? 'test'
        edges.group_by { |e| e['node']['app']['name'] }
      else
        final_data_set = if data_set == 'user'
                           ShopifyUser.process_data(edges, app_id, time[:end], PLATFORM, cursor)
                         else
                           ShopifyPayment.process_data(edges, app_id, time[:end], PLATFORM, cursor, data_set)
                         end

        start_importer(app_id, api, time, data_set, edges.last['cursor']) if results['pageInfo']['hasNextPage']

        ExternalMetric.where(app_id: app_id, platform_id: PLATFORM, date: time[:end].to_date.strftime('%d-%m-%Y'))
      end
    end
  end
end
