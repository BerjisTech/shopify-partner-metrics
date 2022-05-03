# frozen_string_literal: true

class ShopifyImport < ApplicationRecord
  PLATFORM = Platform.find_by(name: 'Shopify').id

  class << self
    def from_whenever
      ThirdPartyApi.all.map do |api|
        ExternalDataImportJob.set(wait: 10.seconds).perform_later(api.app_id, api,
                                                                  { start: (DateTime.now - 1.days).to_s, end: DateTime.now.to_s }, 'user', '')
        ExternalDataImportJob.set(wait: 20.seconds).perform_later(api.app_id, api,
                                                                  { start: (DateTime.now - 1.days).to_s, end: DateTime.now.to_s }, 'daily_finance', '')
        ExternalDataImportJob.set(wait: 30.seconds).perform_later(api.app_id, api,
                                                                  { start: (DateTime.now - 30.days).to_s, end: DateTime.now.to_s }, 'monthly_finance', '')
      end
    end

    def start_importer(app_id, api, time, data_set, cursor = '')
      log_time = DateTime.now
      ImportLog.create!({ platform_id: PLATFORM, app_id: app_id, start_time: log_time, status: 0 })

      run_data(app_id, api, time, data_set, cursor, log_time)
    end

    def run_data(app_id, api, time, data_set, cursor, log_time)
      received_data = pick_importer(api, data_set, time, cursor)
      data = received_data.body

      unless data.present?
        return ErrorLog.create({ activity: App.find(app_id).app_name.to_s, message: 'No data received from Shopify',
                                 logs: received_data.inspect })
      end

      if data['errors'].present?
        return ErrorLog.create({ activity: App.find(app_id).app_name.to_s, message: 'No data received from Shopify',
                                 logs: data.inspect })
      end

      data = JSON.parse(data)

      records = OpenStruct.new data['data']

      unless records.present?
        return ErrorLog.create({ activity: App.find(app_id).app_name.to_s, message: 'Data.data is nil',
                                 logs: data })
      end

      process(app_id, api, time, records, data_set, cursor, log_time) if records.present?
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
      Faraday.post(path, body, header)
    end

    def process(app_id, api, time, records, data_set, cursor, log_time)
      unless records['app'].present? || records['transactions'].present?
        return ErrorLog.create({ activity: App.find(app_id).app_name.to_s,
                                 message: 'No app or transactions data received from Shopify', logs: records.inspect })
      end

      results = if data_set == 'user'
                  records['app']['events']
                else
                  records['transactions']
                end

      unless results.present? && results.size.positive?
        return ErrorLog.create({ activity: App.find(app_id).app_name.to_s,
                                 message: 'App events or transactions data not found', logs: records.inspect })
      end

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
          AwaitQueJob.set(wait: 2.seconds).perform_later(app_id, api, time, data_set,
                                                         edges.last['cursor'], log_time)
        else
          ImportLog.where(platform_id: PLATFORM, app_id: app_id, start_time: log_time,
                          status: 0).update_all({ status: 1, end_time: DateTime.now })
        end

        ExternalMetric.where(app_id: app_id, platform_id: PLATFORM, date: time[:end].to_date.strftime('%d-%m-%Y'))
      end
    end
  end
end
