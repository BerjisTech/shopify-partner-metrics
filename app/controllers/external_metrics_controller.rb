# frozen_string_literal: true

class ExternalMetricsController < ApplicationController
  before_action :set_external_metric, only: %i[show edit update destroy]

  # GET /external_metrics or /external_metrics.json
  def index
    @external_metrics = ExternalMetric.all
  end

  def main_external_bar
    external_metrics = ExternalMetric.fetch_business_net(current_user.id, params[:from].to_i, params[:to].to_i)
    keys = external_metrics.sort.group_by(&:date).keys
    apps = external_metrics.sort.group_by(&:app_name).keys
    values = []
    dates = []
    external_metrics.map { |m| dates << m.date.strftime('%d %b, %Y') }

    sets = []

    apps.each do |app|
      sets << {
        title: app,
        values: app_chart_values(external_metrics.filter { |e| e.app_name == app })
      }
    end

    render json: {
      type: '',
      status: '',
      message: '',
      chart_type: 'bar',
      blocks: keys.count,
      sets: sets.filter { |f| f[:values].sum.positive? },
      keys: dates.uniq,
      values: [],
      title: 'App Revenue By Date'
    }
  end

  def app_chart_values(block)
    data = []
    block.each { |b| data << b.value.to_i }
    data
  end

  def main_external_pie
    external_metrics = ExternalMetric.fetch_business_pie(current_user.id)
    keys = external_metrics.group_by(&:app_name).keys

    values = []
    external_metrics.map { |m| values << (m.value || 0).round(2) }

    render json: {
      type: '',
      status: '',
      message: '',
      chart_type: 'doughnut',
      blocks: 0,
      sets: external_metrics,
      keys: keys,
      values: values,
      title: 'App Revenue Comparison'
    }
  end

  # GET /external_metrics/1 or /external_metrics/1.json
  def show; end

  # GET /external_metrics/new
  def new
    @external_metric = ExternalMetric.new
  end

  # GET /external_metrics/1/edit
  def edit; end

  # POST /external_metrics or /external_metrics.json
  def create
    @external_metric = ExternalMetric.new(external_metric_params)

    respond_to do |format|
      if @external_metric.save
        format.html do
          redirect_to external_metric_url(@external_metric), notice: 'External metric was successfully created.'
        end
        format.json { render :show, status: :created, location: @external_metric }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @external_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /external_metrics/1 or /external_metrics/1.json
  def update
    respond_to do |format|
      if @external_metric.update(external_metric_params)
        format.html do
          redirect_to external_metric_url(@external_metric), notice: 'External metric was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @external_metric }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @external_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_metrics/1 or /external_metrics/1.json
  def destroy
    @external_metric.destroy

    respond_to do |format|
      format.html { redirect_to external_metrics_url, notice: 'External metric was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_external_metric
    @external_metric = ExternalMetric.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def external_metric_params
    params.require(:external_metric).permit(:app_id, :gross, :net, :trial, :paying_users, :trial_users, :new_users, :deactivations, :date,
                                            :reactivations, :lost_users, :mrr_chrun, :user_churn, :arpu, :recurring_revenue, :one_time_charge, :refunds, :arr)
  end
end
