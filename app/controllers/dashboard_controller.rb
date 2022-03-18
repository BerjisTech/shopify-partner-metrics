# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @data_keys = %w[
      January
      February
      March
      April
      May
      June
    ]
    @data_values = [0, 10, 5, 2, 20, 30, 45]
  end
end
