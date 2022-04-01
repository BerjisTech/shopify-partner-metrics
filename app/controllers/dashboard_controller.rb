# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @running_metrics = running_metrics
    @external_metrics = external_metrics

    render json: ShopifyImport.start_importer(App.first.id,
                                              { start: (DateTime.now - 30.days).to_s, end: DateTime.now.to_s }, 'user')
  end

  def running_metrics
    data_keys = {}
    data_values = {}
    { keys: data_keys, values: data_values }
  end

  def external_metrics
    data = App.mine(current_user.id).joins(:external_metrics).where('external_metrics.created_at > ?',
                                                                    7.days.ago).order('external_metrics.created_at DESC')
    data_keys = {}
    data_values = {}
    { keys: data_keys, values: data_values }
  end
end
