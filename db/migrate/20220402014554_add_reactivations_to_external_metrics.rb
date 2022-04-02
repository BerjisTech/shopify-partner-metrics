# frozen_string_literal: true

class AddReactivationsToExternalMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :external_metrics, :reactivations, :integer
  end
end
