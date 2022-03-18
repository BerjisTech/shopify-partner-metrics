# frozen_string_literal: true

class RunningDataEndpointsController < ApplicationController
  before_action :set_running_data_endpoint, only: %i[show edit update destroy]

  # GET /running_data_endpoints or /running_data_endpoints.json
  def index
    @running_data_endpoints = RunningDataEndpoint.all
  end

  # GET /running_data_endpoints/1 or /running_data_endpoints/1.json
  def show; end

  # GET /running_data_endpoints/new
  def new
    @running_data_endpoint = RunningDataEndpoint.new
  end

  # GET /running_data_endpoints/1/edit
  def edit; end

  # POST /running_data_endpoints or /running_data_endpoints.json
  def create
    @running_data_endpoint = RunningDataEndpoint.new(running_data_endpoint_params)

    respond_to do |format|
      if @running_data_endpoint.save
        format.html do
          redirect_to running_data_endpoint_url(@running_data_endpoint),
                      notice: 'Running data endpoint was successfully created.'
        end
        format.json { render :show, status: :created, location: @running_data_endpoint }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @running_data_endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /running_data_endpoints/1 or /running_data_endpoints/1.json
  def update
    respond_to do |format|
      if @running_data_endpoint.update(running_data_endpoint_params)
        format.html do
          redirect_to running_data_endpoint_url(@running_data_endpoint),
                      notice: 'Running data endpoint was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @running_data_endpoint }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @running_data_endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /running_data_endpoints/1 or /running_data_endpoints/1.json
  def destroy
    @running_data_endpoint.destroy

    respond_to do |format|
      format.html do
        redirect_to running_data_endpoints_url, notice: 'Running data endpoint was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_running_data_endpoint
    @running_data_endpoint = RunningDataEndpoint.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def running_data_endpoint_params
    params.require(:running_data_endpoint).permit(:app_id, :endpoint, :data_rounds)
  end
end
