# frozen_string_literal: true

json.array! @running_metrics, partial: 'running_metrics/running_metric', as: :running_metric
