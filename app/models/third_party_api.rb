# frozen_string_literal: true

class ThirdPartyApi < ApplicationRecord
  belongs_to :app
  belongs_to :platform
  class << self
    def mine(user_id)
      joins(app: :app_teams).joins(:platform).where('app_teams.user_id' => user_id).select(:id,
                                                                                           :app_name, 'platforms.name as platform_name', 'platforms.id as platform_id', 'third_party_apis.created_at', 'third_party_apis.updated_at', :api_key, :api_secret, :secondary_api_key, :secondary_api_secret, :partner_id, :app_code)
    end

    def update_from_app(data, app, thrid_party_data)
      if data[:api_key].present?
        ThirdPartyApi.where(app_id: app.id,
                            platform_id: thrid_party_data[:platform_id]).update_all(api_key: data[:api_key])
      end
      if data[:api_secret].present?
        ThirdPartyApi.where(app_id: app.id,
                            platform_id: thrid_party_data[:platform_id]).update_all(api_secret: data[:api_secret])
      end
      if data[:app_code].present?
        ThirdPartyApi.where(app_id: app.id,
                            platform_id: thrid_party_data[:platform_id]).update_all(app_code: data[:app_code])
      end
      if data[:partner_id].present?
        ThirdPartyApi.where(app_id: app.id,
                            platform_id: thrid_party_data[:platform_id]).update_all(partner_id: data[:partner_id])
      end
    end
  end
end
