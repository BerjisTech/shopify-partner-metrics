# frozen_string_literal: true

class CreateDocsCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :docs_categories, id: :uuid do |t|
      t.text :name

      t.timestamps
    end
    add_index :docs_categories, :name
  end
end
