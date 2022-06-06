# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans, id: :uuid do |t|
      t.string :name
      t.boolean :has_exports
      t.boolean :has_breakdown
      t.float :price
      t.boolean :has_csv_import

      t.timestamps
    end

    add_index :plans, :name
    add_index :plans, :has_exports
    add_index :plans, :has_breakdown
    add_index :plans, :has_csv_import
  end
end
