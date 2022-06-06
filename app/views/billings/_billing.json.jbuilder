json.extract! billing, :id, :app_id, :user_id, :business_id, :amount, :plan_id, :created_at, :updated_at
json.url billing_url(billing, format: :json)
