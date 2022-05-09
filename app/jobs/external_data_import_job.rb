# frozen_string_literal: true

class ExternalDataImportJob < ApplicationJob
  queue_as :default

  def perform(app_id, api, time, data_set, cursor)
    # Do something later
    ShopifyImport.start_importer(app_id, api, time, data_set, cursor)
  end
end
