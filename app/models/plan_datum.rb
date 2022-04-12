# frozen_string_literal: true

class PlanDatum < ApplicationRecord
  belongs_to :app_plan, foreign_key: :plan_id
  belongs_to :app
end
