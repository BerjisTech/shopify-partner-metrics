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
      Staff.where(user_id: user_id).joins(:business).select_all
    end
  end
end
