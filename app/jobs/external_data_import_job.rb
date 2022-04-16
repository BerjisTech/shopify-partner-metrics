class ExternalDataImportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    ShopifyImport.start_importer(app_id, api, time, data_set, cursor)
    RunningDataImporterJob.set(wait: 24.hours).perform_later(app_id, endpoint)
  end
end
