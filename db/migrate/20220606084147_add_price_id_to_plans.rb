class AddPriceIdToPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :price_id, :text
  end
end
