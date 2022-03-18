# frozen_string_literal: true

class CreatePlatforms < ActiveRecord::Migration[6.1]
  def change
    create_table :platforms, id: :uuid do |t|
      t.text :name

      t.timestamps
    end
  end
end
