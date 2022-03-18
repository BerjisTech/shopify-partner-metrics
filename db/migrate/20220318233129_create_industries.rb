# frozen_string_literal: true

class CreateIndustries < ActiveRecord::Migration[6.1]
  def change
    create_table :industries, id: :uuid do |t|
      t.text :name

      t.timestamps
    end
  end
end
