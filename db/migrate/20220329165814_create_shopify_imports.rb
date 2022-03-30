class CreateShopifyImports < ActiveRecord::Migration[6.1]
  def change
    create_table :shopify_imports, id: :uuid do |t|

      t.timestamps
    end
  end
end
