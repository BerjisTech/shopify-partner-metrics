class PlanDataController < ApplicationController
  before_action :set_plan_datum, only: %i[ show edit update destroy ]

  # GET /plan_data or /plan_data.json
  def index
    @plan_data = PlanDatum.all
  end

  # GET /plan_data/1 or /plan_data/1.json
  def show
  end

  # GET /plan_data/new
  def new
    @plan_datum = PlanDatum.new
  end

  # GET /plan_data/1/edit
  def edit
  end

  # POST /plan_data or /plan_data.json
  def create
    @plan_datum = PlanDatum.new(plan_datum_params)

    respond_to do |format|
      if @plan_datum.save
        format.html { redirect_to plan_datum_url(@plan_datum), notice: "Plan datum was successfully created." }
        format.json { render :show, status: :created, location: @plan_datum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @plan_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plan_data/1 or /plan_data/1.json
  def update
    respond_to do |format|
      if @plan_datum.update(plan_datum_params)
        format.html { redirect_to plan_datum_url(@plan_datum), notice: "Plan datum was successfully updated." }
        format.json { render :show, status: :ok, location: @plan_datum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @plan_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plan_data/1 or /plan_data/1.json
  def destroy
    @plan_datum.destroy

    respond_to do |format|
      format.html { redirect_to plan_data_url, notice: "Plan datum was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan_datum
      @plan_datum = PlanDatum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plan_datum_params
      params.require(:plan_datum).permit(:app_id, :plan_id, :plan_paying_users, :plan_trial_users, :plan_total_users)
    end
end
