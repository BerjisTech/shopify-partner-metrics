# frozen_string_literal: true

json.array! @running_data, partial: 'running_data/running_datum', as: :running_datum
