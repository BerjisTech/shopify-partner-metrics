# frozen_string_literal: true

class Platform < ApplicationRecord
  has_many :apps
end
