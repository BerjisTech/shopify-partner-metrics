# frozen_string_literal: true

class AddAppNameToExternalMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :external_metrics, :app_name, :string, default: 0
  end
end
