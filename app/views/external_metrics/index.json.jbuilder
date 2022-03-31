# frozen_string_literal: true

json.array! @external_metrics, partial: 'external_metrics/external_metric', as: :external_metric
