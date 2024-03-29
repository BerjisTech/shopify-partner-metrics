# frozen_string_literal: true

class App < ApplicationRecord
  has_many :app_plans
  has_many :app_teams
  has_many :third_party_apis
  has_many :plan_data
  has_many :running_data
  has_many :external_metrics
  has_many :running_metrics
  has_many :shopify_user_activities

  belongs_to :business
  belongs_to :platform

  class << self
    def mine(user_id)
      joins(:platform).joins(:business).joins(:app_teams).joins('LEFT JOIN PLANS ON plans.id = apps.current_plan').where('app_teams.user_id': user_id).select(
        'apps.id as id, app_teams.id as team_id', :platform_id, :user_id, :app_name, 'platforms.name as platform_name', :app_url, :running_data_endpoint, 'apps.created_at', 'apps.last_paid_on', 'plans.price_id', 'apps.current_plan', 'apps.updated_at', 'apps.next_bill_date', 'plans.name as plan_name'
      )
    end

    def per_business(business_id)
      joins(:platform).joins(:business).where(business_id: business_id).select('apps.id as id', :platform_id, :user_id,
                                                                               :app_name, :name, :app_url, :running_data_endpoint, 'apps.created_at', 'apps.updated_at')
    end

    def latest_gross_paying_mrr(app_id)
      latest_paying_mrr = RunningMetric.where(app_id: app_id).last
      if latest_paying_mrr.present?
        "$ #{number_with_precision(latest_paying_mrr.gross_paying_mrr, precision: 2, delimiter: ',', separator: '.')}"
      else
        '$ 0'
      end
    end

    def latest_gross_trial_mrr(app_id)
      latest_trial_mrr = RunningMetric.where(app_id: app_id).last
      if latest_trial_mrr.present?
        "$ #{number_with_precision(latest_trial_mrr.gross_trial_mrr, precision: 2, delimiter: ',', separator: '.')}"
      else
        '$ 0'
      end
    end

    def latest_total_users(app_id)
      latest_users = RunningMetric.where(app_id: app_id).last
      if latest_users.present?
        "$ #{number_with_precision(latest_users.gross_paying_users + latest_users.gross_trial_users,
                                   precision: 2, delimiter: ',', separator: '.')}"
      else
        '$ 0'
      end
    end

    def latest_arpu(app_id)
      latest_users = RunningMetric.where(app_id: app_id).last
      if latest_users.present?
        "$ #{number_with_precision(
          latest_users.gross_paying_mrr / (latest_users.gross_paying_users + latest_users.gross_trial_users), precision: 2, delimiter: ',', separator: '.'
        )}"
      else
        '$ 0'
      end
    end

    def mrr_at(date, app_id)
      mrr = RunningMetric.find_or_create_by(app_id: app_id, date: date)
      if mrr.present?
        "$ #{number_with_precision(mrr.gross_paying_mrr, precision: 2, delimiter: ',', separator: '.')}"
      else
        '$ 0'
      end
    end

    def latest_external_metric(app_id)
      latest = ExternalMetric.where(app_id: app_id, date: Date.today)
      latest = ExternalMetric.where(app_id: app_id, date: Date.today - 1.days) if latest.blank?
      latest
    end

    def monthly_external_metric(app_id)
      ExternalMetric.where(app_id: app_id).where(date: (Date.today - 30.days)..Date.today).order(date: :ASC)
    end

    def clear_all
      App.destroy_all
      AppTeam.destroy_all
      Business.destroy_all
      ExternalMetric.destroy_all
      Industry.destroy_all
      PlanDatum.destroy_all
      AppPlan.destroy_all
      RunningDatum.destroy_all
      RunningMetric.destroy_all
      ShopifyImport.destroy_all
      ShopifyUser.destroy_all
      ShopifyPayment.destroy_all
      Staff.destroy_all
      StripeImport.destroy_all
      ThirdPartyApi.destroy_all
    end
  end
end
