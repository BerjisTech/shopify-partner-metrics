# frozen_string_literal: true

class App < ApplicationRecord
  has_many :app_plans
  has_many :third_party_apis
  has_many :plan_data
  has_many :running_data

  belongs_to :running_data_endpoint
  belongs_to :business
end
