# frozen_string_literal: true

class Business < ApplicationRecord
  has_many :apps
  has_many :staffs
  has_many :invites
  has_many :invite_accepts

  belongs_to :industry
  belongs_to :user

  class << self
    def mine(user_id)
      Business.where(user_id: user_id)
    end
  end
end
