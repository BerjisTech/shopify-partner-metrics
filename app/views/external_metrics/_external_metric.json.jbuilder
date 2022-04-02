# frozen_string_literal: true

json.extract! external_metric, :id, :app_id, :gross, :net, :trial, :paying_users, :trial_users, :reactivations, :new_users,
              :deactivations, :lost_users, :mrr_chrun, :user_churn, :arpu, :recurring_revenue, :one_time_charge, :refunds, :arr, :date, :created_at, :updated_at
json.url external_metric_url(external_metric, format: :json)
