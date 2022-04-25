# frozen_string_literal: true

class ThirdPartyApisController < ApplicationController
  before_action :set_third_party_api, only: %i[show edit update destroy]

  # GET /third_party_apis or /third_party_apis.json
  def index
    @third_party_apis = ThirdPartyApi.mine(current_user.id)
    # render json: PaymentHistory.where(app_id: '22769f8b-e015-42c2-a947-873410d4a62c').group(:payment_date).order(:payment_date).pluck(:payment_date)
  end

  # GET /third_party_apis/1 or /third_party_apis/1.json
  def show
    # render json: @third_party_api
  end

  # GET /third_party_apis/new
  def new
    @third_party_api = ThirdPartyApi.new
  end

  def shopify_importer_setup
    file = params[:shopify]
    message = {}
    user_id = current_user.id

    if file.nil?
      message = { status: nil, data: params }
    else
      satus = nil
      csv_file = format_file(file)

      extracted_data = FileFormat.extract_data(csv_file, user_id)

      no_apps = find_missing_apps(extracted_data.keys)

      status = 'no_apps' if no_apps.size.positive?

      message = {
        status: status,
        data: {
          grouped: extracted_data,
          not_found: no_apps
        }
      }
    end
    render json: message
  end

  def format_file(file)
    case file.content_type
    when 'text/csv'
      file
    when 'application/x-zip-compressed'
      FileFormat.unzip_file(file)
    else
      { status: 'error', message: 'Please provide a zip or csv file' }
    end
  end

  def find_missing_apps(keys)
    apps = []
    keys.each do |key|
      unless App.where(app_name: key).joins('INNER JOIN app_teams on app_teams.app_id = apps.id').where('app_teams.user_id': current_user.id).blank?
        next
      end

      app_name = (key.nil? ? 'Other' : key)
      FileFormat.create_app(app_name, current_user.id)

      app = App.find_by(app_name: app_name)
      app_path = app.present? ? edit_app_path(app.id) : '#'
      apps << [app_name, app_path]
    end
    apps
  end

  # GET /third_party_apis/1/edit
  def edit; end

  # POST /third_party_apis or /third_party_apis.json
  def create
    @third_party_api = ThirdPartyApi.new(third_party_api_params)

    respond_to do |format|
      if @third_party_api.save
        format.html do
          redirect_to third_party_api_url(@third_party_api), notice: 'Third party api was successfully created.'
        end
        format.json { render :show, status: :created, location: @third_party_api }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @third_party_api.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /third_party_apis/1 or /third_party_apis/1.json
  def update
    respond_to do |format|
      if @third_party_api.update(third_party_api_params)
        format.html do
          redirect_to third_party_api_url(@third_party_api), notice: 'Third party api was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @third_party_api }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @third_party_api.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /third_party_apis/1 or /third_party_apis/1.json
  def destroy
    @third_party_api.destroy

    respond_to do |format|
      format.html { redirect_to third_party_apis_url, notice: 'Third party api was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_third_party_api
    @third_party_api = ThirdPartyApi.where(id: params[:id]).joins(:platform).select('third_party_apis.id as id', :partner_id, :app_code, :platform_id, :app_id, :api_key, :api_secret, :secondary_api_key,
                                                                                    :secondary_api_secret, 'platforms.name as name', 'third_party_apis.created_at', 'third_party_apis.updated_at').first
  end

  # Only allow a list of trusted parameters through.
  def third_party_api_params
    params.require(:third_party_api).permit(:platform_id, :app_id, :api_key, :api_secret, :secondary_api_key,
                                            :secondary_api_secret, :partner_id, :app_code)
  end
end
