# frozen_string_literal: true

class AddRunningDataEndpointIdToApps < ActiveRecord::Migration[6.1]
  def change
    add_column :apps, :running_data_endpoint_id, :uuid
  end
end
