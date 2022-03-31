# frozen_string_literal: true

class AppPlan < ApplicationRecord
  belongs_to :app

  class << self
    def demo
      PlanDatum.all
    end

    def create_with(data, app_id)
      AppPlan.find_or_create_by({
                                  app_id: app_id,
                                  plan_name: data['plan_name'],
                                  plan_price: data['plan_price'],
                                  plan_trial_price: data['plan_trial_price'],
                                  trial_days: data['trial_days']
                                })
    end
  end
end
