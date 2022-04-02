# frozen_string_literal: true

class AddDeactivationsToExternalMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :external_metrics, :deactivations, :integer
  end
end
