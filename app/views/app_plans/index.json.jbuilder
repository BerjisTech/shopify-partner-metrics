# frozen_string_literal: true

json.array! @app_plans, partial: 'app_plans/app_plan', as: :app_plan
