class CreateStripeImports < ActiveRecord::Migration[6.1]
  def change
    create_table :stripe_imports, id: :uuid do |t|

      t.timestamps
    end
  end
end
