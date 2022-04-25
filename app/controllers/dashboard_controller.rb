# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @running_metrics = running_metrics
    @external_metrics = external_metrics
    render json: [running_metrics,external_metrics]
  end

  def running_metrics
    RunningMetric.recent_metrics(current_user.id)
  end

  def external_metrics
    ExternalMetric.recent_metrics(current_user.id)
  end
end
