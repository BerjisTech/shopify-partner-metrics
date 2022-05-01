# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @running_metrics = running_metrics
    @external_metrics = external_metrics
    @external_monthly_metrics = external_monthly_metrics
    @pie_keys = external_metrics.group_by(&:app_name).keys
  end

  def running_metrics
    RunningMetric.recent_metrics(current_user.id)
  end

  def external_metrics
    ExternalMetric.recent_metrics(current_user.id)
  end

  def external_monthly_metrics
    ExternalMetric.external_monthly_metrics(current_user.id)
  end
end
