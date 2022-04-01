# frozen_string_literal: true

class ThirdPartyApisController < ApplicationController
  before_action :set_third_party_api, only: %i[show edit update destroy]

  # GET /third_party_apis or /third_party_apis.json
  def index
    @third_party_apis = ThirdPartyApi.joins(:app).joins(:platform).where('apps.user_id' => current_user.id).select(:id,
                                                                                                                   :app_name, 'platforms.name as platform_name', 'platforms.id as platform_id', 'third_party_apis.created_at', 'third_party_apis.updated_at', :api_key, :api_secret, :secondary_api_key, :secondary_api_secret, :partner_id, :app_code)
  end

  # GET /third_party_apis/1 or /third_party_apis/1.json
  def show
    redirect_to edit_third_party_api_path
  end

  # GET /third_party_apis/new
  def new
    @third_party_api = ThirdPartyApi.new
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
    @third_party_api = ThirdPartyApi.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def third_party_api_params
    params.require(:third_party_api).permit(:platform_id, :app_id, :api_key, :api_secret, :secondary_api_key,
                                            :secondary_api_secret)
  end
end
