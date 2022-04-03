# frozen_string_literal: true

class RunningMetricsController < ApplicationController
  before_action :set_running_metric, only: %i[show edit update destroy]

  # GET /running_metrics or /running_metrics.json
  def index
    @running_metrics = RunningMetric.all
    app = App.first
    render json: RunningMetric.start_importer(app.id, app.running_data_endpoint)
  end

  # GET /running_metrics/1 or /running_metrics/1.json
  def show; end

  # GET /running_metrics/new
  def new
    @running_metric = RunningMetric.new
  end

  # GET /running_metrics/1/edit
  def edit; end

  # POST /running_metrics or /running_metrics.json
  def create
    @running_metric = RunningMetric.new(running_metric_params)

    respond_to do |format|
      if @running_metric.save
        format.html do
          redirect_to running_metric_url(@running_metric), notice: 'Running metric was successfully created.'
        end
        format.json { render :show, status: :created, location: @running_metric }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @running_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /running_metrics/1 or /running_metrics/1.json
  def update
    respond_to do |format|
      if @running_metric.update(running_metric_params)
        format.html do
          redirect_to running_metric_url(@running_metric), notice: 'Running metric was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @running_metric }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @running_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /running_metrics/1 or /running_metrics/1.json
  def destroy
    @running_metric.destroy

    respond_to do |format|
      format.html { redirect_to running_metrics_url, notice: 'Running metric was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_running_metric
    @running_metric = RunningMetric.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def running_metric_params
    params.require(:running_metric).permit(:app_id, :gross, :trial, :paying_users, :trial_users, :mrr_chrun,
                                           :user_churn, :arpu)
  end
end
