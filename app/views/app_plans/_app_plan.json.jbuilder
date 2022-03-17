json.extract! app_plan, :id, :app_id, :plan_name, :plan_price, :plan_trial_price, :trial_days, :created_at, :updated_at
json.url app_plan_url(app_plan, format: :json)
