# frozen_string_literal: true

class ExternalMetric < ApplicationRecord
  belongs_to :app
  belongs_to :platform

  class << self
    def start_shopify(app_id); end

    def start_stripe(app_id); end

    def recent_metrics(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id, date: Date.today).order(:gross).select_all
    end

    def fetch_business_net(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).group(:date).select(:date, 'SUM(net) as value')
    end

    def fetch_business_pie(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id, date: Date.today).group('apps.app_name').select(
        'apps.app_name', 'SUM(net) as value'
      )
    end

    def recent_monthly_metrics(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).order(:gross).select_all
    end

    def temp_pull(span)
      platform_id = Platform.find_by(name: 'Shopify').id
      day_start = span + 1
      month_start = span + 30
      time_end = span

      ThirdPartyApi.where(platform_id: platform_id).map do |api|
        ExternalDataImportJob.set(wait: 30.seconds).perform_later(api.app_id, api,
                                                                  { start: (DateTime.now - day_start.days).to_s, end: (DateTime.now - time_end.days).to_s }, 'user', '')
        ExternalDataImportJob.set(wait: 30.seconds).perform_later(api.app_id, api,
                                                                  { start: (DateTime.now - day_start.days).to_s, end: (DateTime.now - time_end.days).to_s }, 'daily_finance', '')
        ExternalDataImportJob.set(wait: 30.seconds).perform_later(api.app_id, api,
                                                                  { start: (DateTime.now - month_start.days).to_s, end: (DateTime.now - time_end.days).to_s }, 'monthly_finance', '')
      end
    end
  end
end
