# frozen_string_literal: true

json.array! @plan_data, partial: 'plan_data/plan_datum', as: :plan_datum
