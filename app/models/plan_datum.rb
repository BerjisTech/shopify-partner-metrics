# frozen_string_literal: true

class PlanDatum < ApplicationRecord
  belongs_to :app_plan
  belongs_to :app
end
