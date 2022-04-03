# frozen_string_literal: true

class AddDateToPlanData < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_data, :date, :datetime
  end
end
