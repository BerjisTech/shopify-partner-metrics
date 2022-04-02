# frozen_string_literal: true

class ShopifyImport < ApplicationRecord
  PLATFORM = Platform.find_by(name: 'Shopify').id
  class << self
    def start_importer(app_id, time, data_set)
      api = ThirdPartyApi.find_by(app_id: app_id, platform_id: PLATFORM)
      data = pick_importer(api, data_set, time, '')

      # process_data(data, app_id, time)
      records = OpenStruct.new data.data

      process(records, data_set)
    end

    def pick_importer(api, data_set, time, cursor)
      if data_set == 'user'
        data_importer(api, ShopifyUser.data(api, time, cursor))
      else
        data_importer(api, ShopifyPayment.data(time, cursor))
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

    def process(records, data_set)
      results = if data_set == 'user'
                  ShopifyUser.process_data(records.events['edges'])
                else
                  ShopifyPayment.process_data(records.transactions['edges'])
                end

      # append_extras(results['edges']) if results['pageInfo']['hasNextPage']
    end
  end
end
