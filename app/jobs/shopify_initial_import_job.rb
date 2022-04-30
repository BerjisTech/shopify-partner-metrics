# frozen_string_literal: true

class ShopifyInitialImportJob < ApplicationJob
  queue_as :default

  def perform(days, api)
    # Do something later
    ExternalMetric.recent(0,days, api)
  end
end
