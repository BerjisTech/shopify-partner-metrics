# frozen_string_literal: true

class ExternalMetric < ApplicationRecord
  belongs_to :app
  belongs_to :platform

  class << self
    def start_shopify(app_id); end

    def start_stripe(app_id); end

    def recent_metrics(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).order(:gross).select_all
    end

    def fetch_business_net(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).group(:date).select(:date, 'SUM(net) as value')
    end

    def fetch_business_pie(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).group('apps.app_name').select(
        'apps.app_name', 'SUM(net) as value'
      )
    end

    def recent_monthly_metrics(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).order(:gross).select_all
    end

    def temp_pull(app_id, start, time_end, data_set)
      api = ThirdPartyApi.find_by(platform_id: Platform.find_by(name: 'Shopify').id, app_id: app_id)

      ExternalDataImportJob.set(wait: 30.seconds).perform_later(app_id, api,
                                                                { start: (DateTime.now - start.days).to_s, end: (DateTime.now - time_end.days).to_s }, data_set, '')
    end
  end
end
