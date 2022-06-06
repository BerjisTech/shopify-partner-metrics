# frozen_string_literal: true

class CreateBillings < ActiveRecord::Migration[6.1]
  def change
    create_table :billings, id: :uuid do |t|
      t.uuid :app_id
      t.uuid :user_id
      t.uuid :business_id
      t.float :amount
      t.uuid :plan_id

      t.timestamps
    end
  end
end
