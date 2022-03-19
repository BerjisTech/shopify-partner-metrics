# frozen_string_literal: true

class RunningDataInApp < ActiveRecord::Migration[6.1]
  def change
    remove_column :apps, :running_data_endpoint_id
    add_column :apps, :running_data_endpoint, :text
    add_column :apps, :data_rounds, :text
  end
end
