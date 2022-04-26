# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @running_metrics = running_metrics
    @external_metrics = external_metrics
    @pie_keys = external_metrics.group_by(&:app_name).keys
    # render json: PaymentHistory.all.group_by(&:payment_date).keys.sort.filter{|f| f.to_s.include? '-01T' }
  end

  def running_metrics
    RunningMetric.recent_metrics(current_user.id)
  end

  def external_metrics
    ExternalMetric.recent_metrics(current_user.id)
  end
end
