# frozen_string_literal: true

json.extract! third_party_api, :id, :platform_id, :api_key, :api_secret, :secondary_api_key, :secondary_api_secret,
              :created_at, :updated_at
json.url third_party_api_url(third_party_api, format: :json)
