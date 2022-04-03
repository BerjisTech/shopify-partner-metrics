# frozen_string_literal: true

class AddDateToRunningMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :running_metrics, :date, :datetime
  end
end
