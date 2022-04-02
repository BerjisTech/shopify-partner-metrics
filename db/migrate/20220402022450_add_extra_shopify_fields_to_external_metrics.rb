# frozen_string_literal: true

class AddExtraShopifyFieldsToExternalMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :external_metrics, :recurring_revenue, :float
    add_column :external_metrics, :one_time_charge, :float
    add_column :external_metrics, :refunds, :float
    add_column :external_metrics, :arr, :float
  end
end
