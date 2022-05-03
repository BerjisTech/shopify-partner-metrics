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

    sets = generate_sets(apps, external_metrics)

    render json: {
      type: '',
      status: '',
      message: '',
      chart_type: 'bar',
      blocks: keys.count,
      sets: sets,
      keys: dates.uniq,
      values: [],
      title: 'App Revenue By Date'
    }
  end

  def generate_sets(data, metrics)
    sets = []
    data.each do |data|
      color = format('%06x', (rand * 0xffffff))
      sets << {
        title: data,
        values: app_chart_values(metrics.filter { |e| e.app_name == data }),
        color: "##{color}"
      }
    end
    sets
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

  def app_revenue_chart
    metrics = ExternalMetric.per_app_per_platform(params[:platform_id], params[:app_id], params[:from].to_i,
                                                  params[:to].to_i)

    render json: revenue_break_down(metrics)
  end

  def user_growth_bar
    metrics = ExternalMetric.fetch_business_user_growth(current_user.id, params[:from].to_i, params[:to].to_i)

    installs = []
    uninstalls = []
    reactivations = []
    deactivations = []

    metrics.map do |metric|
      installs << metric[:new_users].to_f.round(2)
      reactivations << metric[:deactivations].to_f.round(2)
      uninstalls << metric[:lost_users].to_f.round(2) * -1
      deactivations << metric[:reactivations].to_f.round(2) * -1
    end

    sets = [
      {
        title: 'Installs',
        values: installs,
        color: '#08742E'
      },
      {
        title: 'Reactivations',
        values: reactivations,
        color: '#058B31'
      },
      {
        title: 'Uninstalls',
        values: uninstalls,
        color: '#BC0406'
      },
      {
        title: 'Deactivations',
        values: deactivations,
        color: '#690406'
      }
    ]

    dates = []
    metrics.map { |m| dates << m.date.strftime('%d %b, %Y') }

    render json: {
      metrics: metrics,
      type: '',
      status: '',
      message: '',
      chart_type: 'bar',
      blocks: sets.count,
      sets: sets,
      keys: dates.uniq,
      values: [],
      title: 'Revenue Breakdown'
    }
  end

  def business_revenue_breakdown_chart
    metrics = ExternalMetric.business_revenue_breakdown_chart(params[:from].to_i, params[:to].to_i)

    render json: revenue_break_down(metrics)
  end

  def revenue_break_down(metrics)
    one_time = []
    recurring = []
    refunds = []

    metrics.map do |metric|
      one_time << metric[:one_time_charge].to_f.round(2)
      recurring << metric[:recurring_revenue].to_f.round(2)
      refunds << metric[:refunds].to_f.round(2)
    end

    sets = [
      {
        title: 'One Time Charge',
        values: one_time,
        color: '#46708B'
      },
      {
        title: 'Recurring Revenue',
        values: recurring,
        color: '#829A58'
      },
      {
        title: 'Refunds',
        values: refunds,
        color: '#DC9B9B'
      }
    ]

    dates = []
    metrics.map { |m| dates << m.date.strftime('%d %b, %Y') }

    {
      type: '',
      status: '',
      message: '',
      chart_type: 'bar',
      blocks: sets.count,
      sets: sets,
      keys: dates.uniq,
      values: [],
      title: 'Revenue Breakdown'
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
