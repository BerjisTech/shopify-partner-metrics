# frozen_string_literal: true

class AddLastPaidOnToApps < ActiveRecord::Migration[6.1]
  def change
    add_column :apps, :last_paid_on, :datetime
  end
end
