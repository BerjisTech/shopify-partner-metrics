# frozen_string_literal: true

class AddStatusToAppTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :app_teams, :status, :integer
  end
end
