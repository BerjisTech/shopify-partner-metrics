class CreateShopifyUserActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :shopify_user_activities, id: :uuid do |t|
      t.string :activity
      t.uuid :app_id
      t.datetime :date
      t.text :shopify_domain
      t.text :shop_gid
      t.text :descritpion
      t.text :reason

      t.timestamps
    end
    add_index :shopify_user_activities, :app_id
    add_index :shopify_user_activities, :activity
    add_index :shopify_user_activities, :shopify_domain
    add_index :shopify_user_activities, :reason
    add_index :shopify_user_activities, :descritpion
  end
end
