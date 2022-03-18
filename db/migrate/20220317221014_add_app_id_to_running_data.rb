# frozen_string_literal: true

class AddAppIdToRunningData < ActiveRecord::Migration[6.1]
  def change
    add_column :running_data, :app_id, :uuid
  end
end
