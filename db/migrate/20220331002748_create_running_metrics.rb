# frozen_string_literal: true

class CreateRunningMetrics < ActiveRecord::Migration[6.1]
  def change
    create_table :running_metrics, id: :uuid do |t|
      t.uuid :app_id
      t.float :gross
      t.float :trial
      t.integer :paying_users
      t.integer :trial_users
      t.float :mrr_chrun
      t.float :user_churn
      t.float :arpu

      t.timestamps
    end
  end
end
