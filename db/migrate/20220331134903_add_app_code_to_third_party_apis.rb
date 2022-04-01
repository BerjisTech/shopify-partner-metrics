# frozen_string_literal: true

class AddAppCodeToThirdPartyApis < ActiveRecord::Migration[6.1]
  def change
    add_column :third_party_apis, :app_code, :string
  end
end
