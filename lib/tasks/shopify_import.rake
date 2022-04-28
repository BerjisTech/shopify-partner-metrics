# frozen_string_literal: true

namespace :shopify_import do
  desc 'Import Shopify data daily'
  task :initiate do
    ExternalMetric.temp_pull(0)
  end
end
