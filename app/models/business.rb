# frozen_string_literal: true

class Business < ApplicationRecord
  has_many :apps
  has_many :staffs
  has_many :invites
  has_many :invite_accepts
  has_many :running_metrics, through: :apps

  belongs_to :industry
  belongs_to :user

  class << self
    def mine(user_id)
      where('staffs.user_id': user_id)
        .joins(:staffs)
        .joins(:industry)
        .joins('LEFT JOIN apps ON businesses.id = apps.business_id')
        .order('businesses.created_at DESC')
        .group(:id, :name, 'industries.id')
        .select(
          :id, :business_name, :name, 'industries.id as industry_id', 'count(apps.id) as business_apps', :user_id, 'businesses.created_at', 'businesses.updated_at'
        )
    end
  end
end
