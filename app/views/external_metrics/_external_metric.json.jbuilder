json.extract! external_metric, :id, :app_id, :gross, :net, :trial, :paying_users, :trial_users, :new_users, :lost_users, :mrr_chrun, :user_churn, :arpu, :created_at, :updated_at
json.url external_metric_url(external_metric, format: :json)
