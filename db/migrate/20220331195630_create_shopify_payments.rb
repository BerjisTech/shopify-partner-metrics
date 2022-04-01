# frozen_string_literal: true

class CreateShopifyPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :shopify_payments, id: :uuid, &:timestamps
  end
end
