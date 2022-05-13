# frozen_string_literal: true

class MetricsController < ApplicationController
  def users; end

  def gross; end

  def net; end

  def arr; end

  def user_growth; end

  def refunds; end

  def one_time; end

  def recurring; end

  def revenue_breakdown
    @metrics = ExternalMetric.monthly_metrics_for_tables(current_user.id)
    @apps = @metrics.group_by(&:app_name).keys
    @dates = @metrics.group_by(&:date).keys
  end
end
