# frozen_string_literal: true

class RunningDataImporterJob < ApplicationJob
  queue_as :default

  def perform(app_id, endpoint)
    RunningMetric.start_importer(app_id, endpoint)
    RunningDataImporterJob.set(wait: 3.hours).perform_later(app_id, endpoint)
  end
end
