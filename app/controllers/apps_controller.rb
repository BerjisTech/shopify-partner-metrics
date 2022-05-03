# frozen_string_literal: true

class AppsController < ApplicationController
  before_action :set_app, only: %i[show edit update destroy]

  # GET /apps or /apps.json
  def index
    @apps = App.mine(current_user.id)
    app_ids = @apps.group_by(&:id).keys
    metrics = ExternalMetric.where(app_id: app_ids, date: Date.today).select(:net, :app_id)
    metrics = ExternalMetric.where(app_id: app_ids, date: Date.today - 1.days).select(:net, :app_id) if metrics.blank?
    @import_logs = ImportLog.where(app_id: app_ids)
    @metrics = metrics
  end

  # GET /apps/1 or /apps/1.json
  def show
    @external_metric = App.latest_external_metric(@app.id)
    @external_monthly_metric = App.monthly_external_metric(@app.id)

    # render json: @external_metric.group_by(&:platform_id).keys
  end

  # GET /apps/new
  def new
    @app = App.new

    if Business.mine(current_user.id).blank?
      business = Business.find_or_create_by(user_id: current_user.id, business_name: 'Default',
                                            industry_id: Industry.find_or_create_by(name: 'Other').id)
      Staff.create({ business_id: business.id, user_id: current_user.id, status: 1, designation: 1 })
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
        AppTeam.create({ user_id: current_user.id, added_by: current_user.id, app_id: @app.id,
                         business_id: @app.business_id })
        api = ThirdPartyApi.find_or_create_by(app_id: @app.id, api_key: params[:app][:api_key],
                                              api_secret: params[:app][:api_secret], platform_id: @app.platform_id, app_code: params[:app][:app_code], partner_id: params[:app][:partner_id])

        set_up_shopify_import(@app.id, api) if api.platform_id == Platform.find_by(name: 'Shopify').id

        format.html { redirect_to app_url(@app), notice: 'App was successfully created.' }
        format.json { render :show, status: :created, location: @app }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_up_shopify_import(app_id, api)
    ExternalMetric.where(app_id: app_id).destroy_all
    ShopifyInitialImportJob.set(wait: 30.seconds).perform_later(0, api)
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
