# frozen_string_literal: true

class CreateInviteAccepts < ActiveRecord::Migration[6.1]
  def change
    create_table :invite_accepts, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :invite_id

      t.timestamps
    end
  end
end
