class AddLastPaidOnToApps < ActiveRecord::Migration[6.1]
  def change
    add_column :apps, :current_plan, :datetime
  end
end
