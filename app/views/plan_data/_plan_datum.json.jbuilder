# frozen_string_literal: true

json.extract! plan_datum, :id, :app_id, :plan_id, :plan_paying_users, :plan_trial_users, :plan_total_users,
              :created_at, :updated_at
json.url plan_datum_url(plan_datum, format: :json)
