# frozen_string_literal: true

class BusinessesController < ApplicationController
  before_action :set_business, only: %i[show edit update destroy]

  # GET /businesses or /businesses.json
  def index
    @businesses = Business.mine(current_user.id)
  end

  # GET /businesses/1 or /businesses/1.json
  def show
    @apps = App.per_business(@business.id)
    @staff = Staff.where(business_id: @business.id).joins(:user).select_all
  end

  # GET /businesses/new
  def new
    @business = Business.new
  end

  # GET /businesses/1/edit
  def edit; end

  # POST /businesses or /businesses.json
  def create
    @business = Business.new(business_params)

    @business.user_id = current_user.id
    respond_to do |format|
      if @business.save
        Staff.create({ business_id: @business.id, user_id: @business.user_id, status: 1, designation: 1 })
        format.html { redirect_to business_url(@business), notice: 'Business was successfully created.' }
        format.json { render :show, status: :created, location: @business }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /businesses/1 or /businesses/1.json
  def update
    respond_to do |format|
      if @business.update(business_params)
        format.html { redirect_to business_url(@business), notice: 'Business was successfully updated.' }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1 or /businesses/1.json
  def destroy
    @business.destroy

    respond_to do |format|
      format.html { redirect_to businesses_url, notice: 'Business was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_business
    @business = Business.where(id: params[:id]).joins(:industry).select('businesses.id as id',
                                                                        'industries.id as industry_id', :name, :business_name).first
  end

  # Only allow a list of trusted parameters through.
  def business_params
    params.require(:business).permit(:business_name, :user_id, :industry_id)
  end
end
