class AddRequestsToDocs < ActiveRecord::Migration[6.1]
  def change
    add_column :docs, :requests, :integer
  end
  add_index :docs, :topic
  add_index :docs, :description
end
