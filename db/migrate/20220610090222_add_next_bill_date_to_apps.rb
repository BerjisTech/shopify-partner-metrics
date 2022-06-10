# frozen_string_literal: true

class AddNextBillDateToApps < ActiveRecord::Migration[6.1]
  def change
    add_column :apps, :next_bill_date, :datetime, default: Date.today + 30.days
  end
end
