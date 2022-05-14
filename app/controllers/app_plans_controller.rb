# frozen_string_literal: true

class AppPlansController < ApplicationController
  before_action :set_app_plan, only: %i[show edit update destroy]
  before_action :redirect

  def redirect
    redirect_to docs_path
  end

  # GET /app_plans or /app_plans.json
  def index
    @app_plans = AppPlan.all
  end

  # GET /app_plans/1 or /app_plans/1.json
  def show; end

  # GET /app_plans/new
  def new
    @app_plan = AppPlan.new
  end

  # GET /app_plans/1/edit
  def edit; end

  # POST /app_plans or /app_plans.json
  def create
    @app_plan = AppPlan.new(app_plan_params)

    respond_to do |format|
      if @app_plan.save
        format.html { redirect_to app_plan_url(@app_plan), notice: 'App plan was successfully created.' }
        format.json { render :show, status: :created, location: @app_plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_plans/1 or /app_plans/1.json
  def update
    respond_to do |format|
      if @app_plan.update(app_plan_params)
        format.html { redirect_to app_plan_url(@app_plan), notice: 'App plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_plans/1 or /app_plans/1.json
  def destroy
    @app_plan.destroy

    respond_to do |format|
      format.html { redirect_to app_plans_url, notice: 'App plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_app_plan
    @app_plan = AppPlan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def app_plan_params
    params.require(:app_plan).permit(:app_id, :plan_name, :plan_price, :plan_trial_price, :trial_days)
  end
end
