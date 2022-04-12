# frozen_string_literal: true

class RunningDataImporterJob < ApplicationJob
  queue_as :default

  def perform(app_id, endpoint)
    # Do something later
    p app_id
    p endpoint
    p 'done'

    RunningMetric.start_importer(app_id, endpoint)
  end
end
