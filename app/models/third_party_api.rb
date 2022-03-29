# frozen_string_literal: true

class ThirdPartyApi < ApplicationRecord
  belongs_to :app
  belongs_to :platform
end
