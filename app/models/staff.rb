# frozen_string_literal: true

class Staff < ApplicationRecord
  belongs_to :business
  belongs_to :user
end
