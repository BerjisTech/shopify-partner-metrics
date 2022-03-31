# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @running_metrics = running_metrics
    @external_metrics = external_metrics
  end

  def running_metrics
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

  def external_metrics
    data = ExternalMetrics.where
    data_keys =
      data_values = [0, 10, 5, 2, 20, 30, 45]
    { keys: data_keys, values: values }
  end
end
