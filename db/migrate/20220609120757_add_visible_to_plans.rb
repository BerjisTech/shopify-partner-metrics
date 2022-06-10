# frozen_string_literal: true

class AddVisibleToPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :visible, :boolean
  end
end
