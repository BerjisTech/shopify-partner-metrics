# frozen_string_literal: true

class CreateStaffs < ActiveRecord::Migration[6.1]
  def change
    create_table :staffs, id: :uuid do |t|
      t.uuid :business_id
      t.uuid :user_id
      t.integer :status
      t.integer :designation

      t.timestamps
    end
  end
end
