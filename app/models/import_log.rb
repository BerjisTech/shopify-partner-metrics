# frozen_string_literal: true

class ImportLog < ApplicationRecord
  class << self
    def incomplete
      joins('INNER JOIN apps ON apps.id = import_logs.app_id').joins('LEFT JOIN platforms ON platforms.id = import_logs.platform_id').where(status: 0).select(
        :name, :app_name, :id, :start_time, :end_time, :status
      )
    end
  end
end
