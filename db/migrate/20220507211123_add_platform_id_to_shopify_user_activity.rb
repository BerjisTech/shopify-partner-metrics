# frozen_string_literal: true

class AddPlatformIdToShopifyUserActivity < ActiveRecord::Migration[6.1]
  def change
    add_column :shopify_user_activities, :platform_id, :uuid, index: :true
  end
end
