# frozen_string_literal: true

class RunningDataImporterJob < ApplicationJob
  queue_as :default

  def perform(app_id, endpoint)
    RunningMetric.start_importer(app_id, endpoint)
  end
end
