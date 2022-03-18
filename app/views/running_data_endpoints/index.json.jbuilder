# frozen_string_literal: true

json.array! @running_data_endpoints, partial: 'running_data_endpoints/running_data_endpoint', as: :running_data_endpoint
