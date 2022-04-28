class ShopifyInitialImportJob < ApplicationJob
  queue_as :default

  def perform(days, api)
    # Do something later
      ExternalMetric.recent(days, api)
  end
end
