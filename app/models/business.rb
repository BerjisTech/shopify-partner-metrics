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
      if App.mine(user_id).nil?
        joins(:staffs).where(user_id: user_id).joins(:industry).joins(:apps).group(:id, :name, 'industries.id').select(
          :id, :business_name, :name, 'industries.id as industry_id', 'count(apps.id) as business_apps', :user_id, 'businesses.created_at', 'businesses.updated_at'
        )
      else
        joins(:staffs).where(user_id: user_id).joins(:industry).group(:id, :name, 'industries.id').select(
          :id, :business_name, :name, 'industries.id as industry_id', '0 as business_apps', :user_id, 'businesses.created_at', 'businesses.updated_at'
        )
      end
    end
  end
end
