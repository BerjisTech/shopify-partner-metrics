# frozen_string_literal: true

class RunningMetric < ApplicationRecord
  belongs_to :app

  class << self
    def start_importer(app_id, endpoint)
      data = Faraday.get(endpoint)

      errors = verify_data(data)

      if errors.size.positive?
        errors
      else
        save_metric_data(data[:metrics], app_id)
        save_plan(data[:plans], app_id)
      end
    end

    def verify_data(data)
      errors = []

      errors << 'Metric data not found' if data.metrics.blank? || data.metrics.nil? || data.metrics.empty?
      errors << 'Plan data not found' if data.plans.blank? || data.plans.nil? || data.plans.empty?

      errors
    end

    def save_metric_data(data, app_id, _running_metric)
      RunningMetric.where(app_id: app_id, date: Date.today.strftime('%d-%m-%Y')).destroy
      RunningMetric.create({ app_id: app_id, date: Date.today.strftime('%d-%m-%Y') }).update(data)
    end

    def save_plan(data, app_id)
      app_plan = AppPlan.find_or_create_by({
                                             app_id: app_id,
                                             plan_name: data['plan_name'],
                                             plan_price: data['plan_price'],
                                             trial_days: data['trial_days']
                                           })
      save_plan_data(data, app_id, app_plan)
    end

    def save_plan_data(data, app_id, app_plan)
      PlanDatum.where(app_id: app_id, plan_id: app_plan.id, date: Date.today.strftime('%d-%m-%Y')).destroy
      PlanDatum.create({
                         app_id: app_id,
                         plan_id: app_plan.id,
                         plan_paying_users: data['plan_paying_users'],
                         plan_trial_users: data['plan_trial_users'],
                         plan_total_users: data['plan_total_users'],
                         date: Date.today.strftime('%d-%m-%Y')
                       })
    end

    def calculate_user_churn(app_id); end
    def calculate_mrr_churn(app_id); end
    def calculate_arpu_churn(app_id); end

    def recent_metrics(user_id)
      Business.mine(user_id)
    end
  end
end
