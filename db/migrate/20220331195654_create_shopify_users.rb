# frozen_string_literal: true

class CreateShopifyUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :shopify_users, id: :uuid, &:timestamps
  end
end
