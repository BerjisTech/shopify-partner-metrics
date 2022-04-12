class RunningMetricsJob
  include Sidekiq::Job

  def perform(app_id, endpoint)
    p app_id
    p endpoint
    p 'done'

    RunningMetric.start_importer(app_id, endpoint)
  end
end
