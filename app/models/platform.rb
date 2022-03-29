# frozen_string_literal: true

class Platform < ApplicationRecord
  has_many :apps
  has_many :third_party_apis
end
