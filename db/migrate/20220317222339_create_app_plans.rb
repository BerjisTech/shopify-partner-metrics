class CreateAppPlans < ActiveRecord::Migration[6.1]
  def change
    create_table :app_plans, id: :uuid do |t|
      t.uuid :app_id
      t.text :plan_name
      t.float :plan_price
      t.float :plan_trial_price
      t.integer :trial_days

      t.timestamps
    end
  end
end
