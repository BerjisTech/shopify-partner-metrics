# frozen_string_literal: true

class Business < ApplicationRecord
  has_many :apps
  belongs_to :industry
end
