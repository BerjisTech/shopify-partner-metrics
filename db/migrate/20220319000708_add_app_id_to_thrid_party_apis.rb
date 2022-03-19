# frozen_string_literal: true

class AddAppIdToThridPartyApis < ActiveRecord::Migration[6.1]
  def change
    add_column :third_party_apis, :app_id, :uuid
  end
end
