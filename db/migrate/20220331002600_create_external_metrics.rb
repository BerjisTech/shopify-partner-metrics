# frozen_string_literal: true

class CreateExternalMetrics < ActiveRecord::Migration[6.1]
  def change
    create_table :external_metrics, id: :uuid do |t|
      t.uuid :app_id
      t.float :gross
      t.float :net
      t.float :trial
      t.integer :paying_users
      t.integer :trial_users
      t.integer :new_users
      t.integer :lost_users
      t.float :mrr_chrun
      t.float :user_churn
      t.float :arpu

      t.timestamps
    end
  end
end
