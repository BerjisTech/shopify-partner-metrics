# frozen_string_literal: true

json.extract! app, :id, :app_name, :user_id, :platform_id, :created_at, :updated_at
json.url app_url(app, format: :json)
