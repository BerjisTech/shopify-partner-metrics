class AddPlatformIdToExternalMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :external_metrics, :platform_id, :uuid
  end
end
