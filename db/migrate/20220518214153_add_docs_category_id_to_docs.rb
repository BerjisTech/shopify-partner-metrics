class AddDocsCategoryIdToDocs < ActiveRecord::Migration[6.1]
  def change
    add_column :docs, :docs_category_id, :uuid
  end
end
