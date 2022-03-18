# frozen_string_literal: true

class AppPlan < ApplicationRecord
  belongs_to :app

  class << self
    def demo
      PlanDatum.all
    end
  end
end
