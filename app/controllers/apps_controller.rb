# frozen_string_literal: true

class AppsController < ApplicationController
  before_action :set_app, only: %i[show edit update destroy]

  # GET /apps or /apps.json
  def index
    @apps = App.mine(current_user.id)
  end

  # GET /apps/1 or /apps/1.json
  def show; end

  # GET /apps/new
  def new
    @app = App.new

    if Business.mine(current_user.id).blank?
      business = Business.find_or_create_by(user_id: current_user.id, business_name: 'Default',
                                 industry_id: Industry.find_or_create_by(name: 'Other').id)
      Staff.create({business_id: business.id, user_id: current_user.id, status: 1, designation: 1})
    end
  end

  # GET /apps/1/edit
  def edit; end

  # POST /apps or /apps.json
  def create
    @app = App.new(app_params)

    @app.user_id = current_user.id

    respond_to do |format|
      if @app.save
        AppTeam.create({user_id: current_user.id, added_by: current_user.id, app_id: @app.id, business_id: @app.business_id})
        ThirdPartyApi.find_or_create_by(app_id: @app.id, api_key: params[:app][:api_key],
                                        api_secret: params[:app][:api_secret], platform_id: @app.platform_id, app_code: params[:app][:app_code], partner_id: params[:app][:partner_id])

        format.html { redirect_to app_url(@app), notice: 'App was successfully created.' }
        format.json { render :show, status: :created, location: @app }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apps/1 or /apps/1.json
  def update
    respond_to do |format|
      if @app.update(app_params)
        ThirdPartyApi.update_from_app(params[:app], @app, app_params[:platform_id])

        format.html { redirect_to app_url(@app), notice: 'App was successfully updated.' }
        format.json { render :show, status: :ok, location: @app }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1 or /apps/1.json
  def destroy
    @app.destroy

    respond_to do |format|
      format.html { redirect_to apps_url, notice: 'App was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_app
    @app = App.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def app_params
    params.require(:app).permit(:app_name, :user_id, :platform_id, :business_id, :app_url, :running_data_endpoint)
  end
end
