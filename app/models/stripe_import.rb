# frozen_string_literal: true

class StripeImport < ApplicationRecord
  PLATFORM = Platform.find_by(name: 'Stripe').id
  class << self
    def start_importer(app_id, time)
      api = ThirdPartyApi.find_by(app_id: app_id, platform_id: PLATFORM)
      secret = api.api_secret
      format_data(secret, time, '', [])
    end

    def format_data(secret, time, last_point, _customers)
      Stripe.api_key = secret
      stripe_data = if last_point.present?
                      stripe_block_with_cursor(time, last_point)
                    else
                      stripe_block(time)
                    end
    end

    def stripe_block(time)
      Stripe::Customer.list(
        {
          limit: 100_000,
          created: {
            gt: time[:start].to_time.to_i,
            lte: time[:end].to_time.to_i
          }
        }
      )
    end

    def stripe_block_with_cursor(time, last_point)
      Stripe::Customer.list(
        {
          limit: 100_000,
          starting_after: last_point,
          created: {
            gt: time[:start].to_time.to_i,
            lte: time[:end].to_time.to_i
          }
        }
      )
    end
  end
end
