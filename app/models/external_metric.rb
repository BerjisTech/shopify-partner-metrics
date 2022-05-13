# frozen_string_literal: true

class ExternalMetric < ApplicationRecord
  belongs_to :app
  belongs_to :platform

  class << self
    def recent_metrics(user_id)
      latest = joins(app: :app_teams).where('app_teams.user_id': user_id,
                                            date: Date.today).order(app_id: :desc).select_all
      if latest.blank?
        latest = joins(app: :app_teams).where('app_teams.user_id': user_id,
                                              date: Date.today - 1.days).order(app_id: :desc).select_all
      end
      latest
    end

    def external_monthly_metrics(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).where('date > ?',
                                                                       30.days.ago).order(date: :asc).order(app_id: :desc).select_all
    end

    def monthly_metrics_for_tables(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).where('date > ?',
                                                                       30.days.ago).order(date: :desc).order(app_id: :asc).select_all
    end

    def fetch_business_net(user_id, from, to)
      joins(app: :app_teams).where('app_teams.user_id': user_id, date: (Date.today - from.days)..(Date.today - to.days)).order(app_id: :desc).order(date: :asc).group('external_metrics.date', 'apps.app_name', 'external_metrics.app_id').select(
        :date, 'SUM(net) as value', 'apps.app_name'
      )
    end

    def fetch_business_user_growth(user_id, from, to)
      joins(app: :app_teams).where('app_teams.user_id': user_id, date: (Date.today - from.days)..(Date.today - to.days)).order(date: :asc).group(:date).select(
        :date, 'SUM(reactivations) reactivations', 'SUM(deactivations) deactivations', 'SUM(new_users) new_users', 'SUM(lost_users) lost_users'
      )
    end

    def fetch_app_user_growth(app_id, from, to)
      where(app_id: app_id, date: (Date.today - from.days)..(Date.today - to.days)).order(date: :asc).group(:date).select(
        :date, 'SUM(reactivations) reactivations', 'SUM(deactivations) deactivations', 'SUM(new_users) new_users', 'SUM(lost_users) lost_users'
      )
    end

    def fetch_business_pie(user_id)
      latest = joins(app: :app_teams).where('app_teams.user_id': user_id, date: Date.today).order(app_id: :desc).group('apps.app_name', 'external_metrics.app_id').select(
        'apps.app_name', 'SUM(net) as value', 'external_metrics.app_id'
      )
      if latest.blank?
        latest = joins(app: :app_teams).where('app_teams.user_id': user_id, date: Date.today - 1.days).order(app_id: :desc).group('apps.app_name', 'external_metrics.app_id').select(
          'apps.app_name', 'SUM(net) as value', 'external_metrics.app_id'
        )
      end
      latest
    end

    def recent_monthly_metrics(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).order(date: :asc).select_all
    end

    def per_app_per_platform(platform_id, app_id, from, to)
      where(date: (Date.today - from.days)..(Date.today - to.days), platform_id: platform_id,
            app_id: app_id).order(date: :asc)
    end

    def business_revenue_breakdown_chart(user_id, from, to)
      joins(app: :app_teams).where('app_teams.user_id': user_id, date: (Date.today - from.days)..(Date.today - to.days)).order(date: :asc).group(:date).select(
        :date, 'SUM(one_time_charge) one_time_charge', 'SUM(recurring_revenue) recurring_revenue', 'SUM(refunds) refunds'
      )
    end

    ################### IMPORT

    def temp_pull(from, span)
      platform_id = Platform.find_by(name: 'Shopify').id

      ThirdPartyApi.where(platform_id: platform_id).each_with_index.map do |api, index|
        ShopifyInitialImportJob.set(wait: (index + 1).minutes).perform_later(from, span, api)
      end
    end

    def recent(from, days, api)
      from.upto(days).map do |span|
        p span
        day_start = span + 1
        month_start = span + 30
        time_end = span

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
