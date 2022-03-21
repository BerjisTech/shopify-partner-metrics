# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://bd1185c38c9b470db0df09d1a5a830ca@o1173753.ingest.sentry.io/6269227'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set tracesSampleRate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
end
