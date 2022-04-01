# frozen_string_literal: true

class AddPartnerIdToThirdPartyApis < ActiveRecord::Migration[6.1]
  def change
    add_column :third_party_apis, :partner_id, :string
  end
end
