# frozen_string_literal: true

class RunningDataImporterJob < ApplicationJob
  queue_as :default

  def perform(app_id, endpoint)
    RunningMetric.start_importer(app_id, endpoint)
    RunningDataImporterJob.set(wait: 24.hours).perform_later(params[:app_id], params[:endpoint])
  end
end
