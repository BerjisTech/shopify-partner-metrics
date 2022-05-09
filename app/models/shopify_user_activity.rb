# frozen_string_literal: true

class ShopifyUserActivity < ApplicationRecord
  belongs_to :app
  belongs_to :platform

  PLATFORM = Platform.find_by(name: 'Shopify').id

  class << self
    def save_for_today(app_id, data, _cursor)
      ShopifyUserActivity.where(app_id: app_id, platform: PLATFORM, created_at: Date.today).destroy_all

      # i['node']['type']
      data.map do |i|
        description = i['node']['description'].present? ? i['node']['description'] : nil
        reason = i['node']['reason'].present? ? i['node']['reason'] : nil
        activity = case i['node']['type']
                   when 'RELATIONSHIP_INSTALLED'
                     'install'
                   when 'RELATIONSHIP_UNINSTALLED'
                     'uninstall'
                   when 'RELATIONSHIP_DEACTIVATED'
                     'deactivated'
                   when 'RELATIONSHIP_REACTIVATED'
                     'reactivated'
                   end

        ShopifyUserActivity.find_or_create_by!(
          activity: activity,
          app_id: app_id,
          platform_id: PLATFORM,
          date: i['node']['occurredAt'].to_date,
          shopify_domain: i['node']['shop']['myshopifyDomain'],
          shop_gid: i['node']['shop']['id'],
          descritpion: description,
          reason: reason
        )
      end
    end

    def for_app(app_id, platform_id, from, to)
      where(app_id: app_id, platform_id: platform_id,
            date: (Date.today - from.days)..(Date.today - to.days)).joins(:app).select_all
    end
  end
end
