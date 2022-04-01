# frozen_string_literal: true

class AppsController < ApplicationController
  before_action :set_app, only: %i[show edit update destroy]

  # GET /apps or /apps.json
  def index
    @apps = App.where(user_id: current_user.id).joins(:platform).select('apps.id', :platform_id, :app_name, :name)
  end

  # GET /apps/1 or /apps/1.json
  def show; end

  # GET /apps/new
  def new
    @app = App.new

    if Business.mine(current_user.id).blank?
      Business.find_or_create_by(user_id: current_user.id, business_name: 'Default',
                                 industry_id: Industry.find_or_create_by(name: 'Other').id)
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
        if params[:app][:api_key].present?
          ThirdPartyApi.where(app_id: @app.id,
                              platform_id: app_params[:platform_id]).update_all(api_key: params[:app][:api_key])
        end
        if params[:app][:apisecrety].present?
          ThirdPartyApi.where(app_id: @app.id,
                              platform_id: app_params[:platform_id]).update_all(api_secret: params[:app][:api_secret])
        end
        if params[:app][:app_code].present?
          ThirdPartyApi.where(app_id: @app.id,
                              platform_id: app_params[:platform_id]).update_all(app_code: params[:app][:app_code])
        end
        if params[:app][:partner_id].present?
          ThirdPartyApi.where(app_id: @app.id,
                              platform_id: app_params[:platform_id]).update_all(partner_id: params[:app][:partner_id])
        end
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
    params.require(:app).permit(:app_name, :user_id, :platform_id, :business_id, :running_data_endpoint)
  end
end
