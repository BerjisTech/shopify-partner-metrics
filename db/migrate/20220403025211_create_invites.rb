# frozen_string_literal: true

class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :invites, id: :uuid do |t|
      t.uuid :business_id
      t.uuid :recepient
      t.uuid :sender
      t.integer :limit
      t.integer :accepts
      t.integer :status

      t.timestamps
    end
  end
end
