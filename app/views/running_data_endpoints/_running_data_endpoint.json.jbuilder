# frozen_string_literal: true

json.extract! running_data_endpoint, :id, :app_id, :endpoint, :data_rounds, :created_at, :updated_at
json.url running_data_endpoint_url(running_data_endpoint, format: :json)
