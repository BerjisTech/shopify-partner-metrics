# frozen_string_literal: true

class RunningDataController < ApplicationController
  before_action :set_running_datum, only: %i[show edit update destroy]

  # GET /running_data or /running_data.json
  def index
    @running_data = RunningDatum.all
  end

  # GET /running_data/1 or /running_data/1.json
  def show; end

  # GET /running_data/new
  def new
    @running_datum = RunningDatum.new
  end

  # GET /running_data/1/edit
  def edit; end

  # POST /running_data or /running_data.json
  def create
    @running_datum = RunningDatum.new(running_datum_params)

    respond_to do |format|
      if @running_datum.save
        format.html { redirect_to running_datum_url(@running_datum), notice: 'Running datum was successfully created.' }
        format.json { render :show, status: :created, location: @running_datum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @running_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /running_data/1 or /running_data/1.json
  def update
    respond_to do |format|
      if @running_datum.update(running_datum_params)
        format.html { redirect_to running_datum_url(@running_datum), notice: 'Running datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @running_datum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @running_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /running_data/1 or /running_data/1.json
  def destroy
    @running_datum.destroy

    respond_to do |format|
      format.html { redirect_to running_data_url, notice: 'Running datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_running_datum
    @running_datum = RunningDatum.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def running_datum_params
    params.require(:running_datum).permit(:date, :gross_paying_mrr, :gross_trial_mrr, :gross_paying_users,
                                          :gross_trial_users)
  end
end
