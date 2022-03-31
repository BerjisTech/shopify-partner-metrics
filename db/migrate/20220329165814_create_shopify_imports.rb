# frozen_string_literal: true

class CreateShopifyImports < ActiveRecord::Migration[6.1]
  def change
    create_table :shopify_imports, id: :uuid, &:timestamps
  end
end
