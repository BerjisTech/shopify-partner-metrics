class CreateAppTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :app_teams, id: :uuid do |t|
      t.uuid :business_id
      t.uuid :app_id
      t.uuid :user_id
      t.uuid :added_by

      t.timestamps
    end
  end
end
