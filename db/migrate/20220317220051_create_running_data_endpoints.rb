# frozen_string_literal: true

class CreateRunningDataEndpoints < ActiveRecord::Migration[6.1]
  def change
    create_table :running_data_endpoints, id: :uuid do |t|
      t.uuid :app_id
      t.text :endpoint
      t.integer :data_rounds

      t.timestamps
    end
  end
end
