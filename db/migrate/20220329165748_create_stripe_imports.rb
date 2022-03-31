# frozen_string_literal: true

class CreateStripeImports < ActiveRecord::Migration[6.1]
  def change
    create_table :stripe_imports, id: :uuid, &:timestamps
  end
end
