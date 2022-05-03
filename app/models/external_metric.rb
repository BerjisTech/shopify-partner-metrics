# frozen_string_literal: true

class ExternalMetric < ApplicationRecord
  belongs_to :app
  belongs_to :platform

  class << self
    def recent_metrics(user_id)
      latest = joins(app: :app_teams).where('app_teams.user_id': user_id, date: Date.today).order(:gross).select_all
      if latest.blank?
        latest = joins(app: :app_teams).where('app_teams.user_id': user_id,
                                              date: Date.today - 1.days).order(:gross).select_all
      end
      latest
    end

    def external_monthly_metrics(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).where('date > ?', 30.days.ago).order(:gross).select_all
    end

    def fetch_business_net(user_id, from, to)
      joins(app: :app_teams).where('app_teams.user_id': user_id, date: (Date.today - from.days)..(Date.today - to.days)).order(date: :asc).group(:date, 'apps.app_name').select(
        :date, 'SUM(net) as value', 'apps.app_name'
      )
    end

    def fetch_business_user_growth(user_id, from, to)
      joins(app: :app_teams).where('app_teams.user_id': user_id, date: (Date.today - from.days)..(Date.today - to.days)).order(date: :asc).group(:date).select(
        :date, 'SUM(reactivations) reactivations', 'SUM(deactivations) deactivations', 'SUM(new_users) new_users', 'SUM(lost_users) lost_users'
      )
    end

    def fetch_business_pie(user_id)
      latest = joins(app: :app_teams).where('app_teams.user_id': user_id, date: Date.today).group('apps.app_name').select(
        'apps.app_name', 'SUM(net) as value'
      )
      if latest.blank?
        latest = joins(app: :app_teams).where('app_teams.user_id': user_id, date: Date.today - 1.days).group('apps.app_name').select(
          'apps.app_name', 'SUM(net) as value'
        )
      end
      latest
    end

    def recent_monthly_metrics(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).order(date: :asc).select_all
    end

    def per_app_per_platform(platform_id, app_id, from, to)
      where(date: (Date.today - from.days)..(Date.today - to.days), platform_id: platform_id, app_id: app_id)
    end

    def business_revenue_breakdown_chart(from, to)
      joins(app: :app_teams).where('app_teams.user_id': user_id)..where(date: (Date.today - from.days)..(Date.today - to.days))
    end

    def temp_pull(from, span)
      platform_id = Platform.find_by(name: 'Shopify').id

      ThirdPartyApi.where(platform_id: platform_id).each_with_index.map do |api, index|
        ShopifyInitialImportJob.set(wait: (index + 1).minutes).perform_later(from, span, api)
      end
    end

    ################### IMPORT

    def recent(from, days, api)
      from.upto(days).map do |span|
        p span
        day_start = span + 1
        month_start = span + 30
        time_end = span

        ExternalMetric.where(platform_id: api.platform_id, app_id: api.app_id,
                             date: (DateTime.now - time_end.days).strftime('%d-%m-%Y'))
        ExternalDataImportJob.set(wait: (span + 1).minutes).perform_later(api.app_id, api,
                                                                          { start: (DateTime.now - month_start.days).to_s, end: (DateTime.now - time_end.days).to_s }, 'monthly_finance', '')

        ExternalDataImportJob.set(wait: (span + 1).minutes).perform_later(api.app_id, api,
                                                                          { start: (DateTime.now - day_start.days).to_s, end: (DateTime.now - time_end.days).to_s }, 'daily_finance', '')

        if api.partner_id.present? && api.app_code.present?
          ExternalDataImportJob.set(wait: (span + 1).minutes).perform_later(api.app_id, api,
                                                                            { start: (DateTime.now - day_start.days).to_s, end: (DateTime.now - time_end.days).to_s }, 'user', '')
        end
      end
    end
  end
end
