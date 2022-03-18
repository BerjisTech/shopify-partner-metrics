# frozen_string_literal: true

class CreatePlanData < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_data, id: :uuid do |t|
      t.uuid :app_id
      t.uuid :plan_id
      t.integer :plan_paying_users
      t.integer :plan_trial_users
      t.integer :plan_total_users

      t.timestamps
    end
  end
end
