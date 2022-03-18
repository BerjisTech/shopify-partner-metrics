# frozen_string_literal: true

class CreateRunningData < ActiveRecord::Migration[6.1]
  def change
    create_table :running_data, id: :uuid do |t|
      t.datetime :date
      t.float :gross_paying_mrr
      t.float :gross_trial_mrr
      t.integer :gross_paying_users
      t.integer :gross_trial_users

      t.timestamps
    end
  end
end
