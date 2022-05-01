# frozen_string_literal: true

class CreateErrorLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :error_logs, id: :uuid do |t|
      t.string :activity
      t.text :message
      t.text :logs

      t.timestamps
    end
  end
end
