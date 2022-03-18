# frozen_string_literal: true

class CreateThirdPartyApis < ActiveRecord::Migration[6.1]
  def change
    create_table :third_party_apis, id: :uuid do |t|
      t.uuid :platform_id
      t.text :api_key
      t.text :api_secret
      t.text :secondary_api_key
      t.text :secondary_api_secret

      t.timestamps
    end
  end
end
