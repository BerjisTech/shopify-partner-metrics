class CreateImportLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :import_logs, id: :uuid do |t|
      t.uuid :platform_id
      t.uuid :app_id
      t.datetime :start_time
      t.datetime :end_time
      t.string :status

      t.timestamps
    end
  end
end
