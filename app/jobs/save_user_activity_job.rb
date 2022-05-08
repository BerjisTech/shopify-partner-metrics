# frozen_string_literal: true

class SaveUserActivityJob < ApplicationJob
  queue_as :default

  def perform(app_id, data, cursor)
    # Do something later
    ShopifyUserActivity.save_for_today(app_id, data, cursor)
  end
end
