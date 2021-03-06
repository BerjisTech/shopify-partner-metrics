# frozen_string_literal: true

class AwaitQueJob < ApplicationJob
  queue_as :default

  def perform(app_id, api, time, data_set, cursor, log_time)
    # Do something later
    ShopifyImport.run_data(app_id, api, time, data_set, cursor, log_time)
  end
end
