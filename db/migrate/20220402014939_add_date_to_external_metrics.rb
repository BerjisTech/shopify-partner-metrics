# frozen_string_literal: true

class AddDateToExternalMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :external_metrics, :date, :datetime
  end
end
