# frozen_string_literal: true

class Invite < ApplicationRecord
  belongs_to :business
  belongs_to :user
end
