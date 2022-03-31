# frozen_string_literal: true

class RunningMetric < ApplicationRecord
  belongs_to :app

  class << self
    def start_importer(_app_id, endpoint)
      data = Faraday.get(endpoint)

      errors = verify_data(data)

      if errors.size.positive?
        errors
      else
        save_data(data, app_id)
      end
    end

    def verify_data(data)
      errors = []

      errors << 'Metric data not found' if data.metrics.blank? || data.metrics.nil? || data.metrics.empty?
      errors << 'Plan data not found' if data.plans.blank? || data.plans.nil? || data.plans.empty?

      errors
    end

    def save_data(data, app_id)
        runningmetric = RunningMetric.create({app_id: app_id})
        runningmetric.update(data)
    end
  end
end
