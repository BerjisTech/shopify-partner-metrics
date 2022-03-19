class ChangeDataRoundsType < ActiveRecord::Migration[6.1]
  def change
    remove_column :apps, :data_rounds
    add_column :apps, :data_rounds, :integer
  end
end
