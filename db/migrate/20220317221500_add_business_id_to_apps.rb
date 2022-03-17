class AddBusinessIdToApps < ActiveRecord::Migration[6.1]
  def change
    add_column :apps, :business_id, :uuid
  end
end
