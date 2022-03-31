# frozen_string_literal: true

json.extract! running_metric, :id, :app_id, :gross, :trial, :paying_users, :trial_users, :mrr_chrun, :user_churn,
              :arpu, :created_at, :updated_at
json.url running_metric_url(running_metric, format: :json)
