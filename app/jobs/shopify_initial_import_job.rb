# frozen_string_literal: true

class ShopifyInitialImportJob < ApplicationJob
  queue_as :default

  def perform(from = 0, days, api)
    # Do something later
    ExternalMetric.recent(from, days, api)
  end
end
