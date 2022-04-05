# frozen_string_literal: true

class AppTeam < ApplicationRecord
  belongs_to :business
  belongs_to :user
  belongs_to :app
end
