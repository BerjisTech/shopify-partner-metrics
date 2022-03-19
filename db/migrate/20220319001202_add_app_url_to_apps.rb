# frozen_string_literal: true

class AddAppUrlToApps < ActiveRecord::Migration[6.1]
  def change
    add_column :apps, :app_url, :text
  end
end
