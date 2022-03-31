# frozen_string_literal: true

class ExternalMetricsController < ApplicationController
  before_action :set_external_metric, only: %i[show edit update destroy]

  # GET /external_metrics or /external_metrics.json
  def index
    @external_metrics = ExternalMetric.all
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
    params.require(:external_metric).permit(:app_id, :gross, :net, :trial, :paying_users, :trial_users, :new_users,
                                            :lost_users, :mrr_chrun, :user_churn, :arpu)
  end
end