# frozen_string_literal: true

class CreateApps < ActiveRecord::Migration[6.1]
  def change
    create_table :apps, id: :uuid do |t|
      t.text :app_name
      t.uuid :user_id
      t.uuid :platform_id

      t.timestamps
    end
  end
end
