# frozen_string_literal: true

class ShopifyUserActivity < ApplicationRecord
  belongs_to :app

  class << self
    def save_for_today(app_id, data)
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
          date: i['node']['occurredAt'].to_date,
          shopify_domain: i['node']['shop']['myshopifyDomain'],
          shop_gid: i['node']['shop']['id'],
          descritpion: description,
          reason: reason
        )
      end
    end
  end
end
