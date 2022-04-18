# frozen_string_literal: true

class CreatePaymentHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_histories, id: :uuid do |t|
      t.text :payout_period
      t.datetime :payment_date, index: true
      t.string :shop
      t.string :shop_country
      t.datetime :charge_creation_time
      t.text :charge_type
      t.string :category
      t.float :partner_sale
      t.float :shopify_fee
      t.float :processing_fee
      t.float :regulatory_operating_fee
      t.float :partner_share
      t.text :app_title
      t.string :theme_name
      t.string :tax_description
      t.string :charge_id
      t.uuid :app_id

      t.timestamps
    end
  end
end
