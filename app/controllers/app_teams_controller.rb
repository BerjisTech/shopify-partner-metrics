# frozen_string_literal: true

class AppTeamsController < ApplicationController
  before_action :set_app_team, only: %i[show edit update destroy]
  before_action :redirect, only: %i[index show edit update destroy]

  def redirect
    redirect_to docs_path
  end

  # GET /app_teams or /app_teams.json
  def index
    @app_teams = AppTeam.all
  end

  def for_app
    @team = AppTeam.where(app_id: params[:app_id]).joins(:user).select(:email, 'app_teams.created_at')
    @app = App.find(params[:app_id])
  end

  # GET /app_teams/1 or /app_teams/1.json
  def show; end

  # GET /app_teams/new
  def new
    redirect_to apps_path if params[:app_id].empty? || params[:app_id].blank?
    @app = App.find(params[:app_id])
    @app_team = AppTeam.new
  end

  # GET /app_teams/1/edit
  def edit; end

  # POST /app_teams or /app_teams.json
  def create
    @app_team = AppTeam.new(app_team_params)
    user = User.find_by(email: params[:app_team]['user_id'])

    respond_to do |format|
      if user.nil?
        @app_team.errors.add(:user_id, 'This user does not exist, ask them to first create an account')
        format.html do
          redirect_to new_app_team_url(app_id: @app_team.app_id),
                      alert: 'This user does not exist, ask them to first create an account'
        end
        format.json { render json: @app_team.errors }
      else
        Staff.find_or_create_by!(user_id: user.id, business_id: @app_team.business_id, status: 1, designation: 2)
        @app_team.user_id = user.id
        if @app_team.save
          format.html { redirect_to team_path(@app_team.app_id), notice: 'App team was successfully created.' }
          format.json { render :show, status: :created, location: @app_team }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @app_team.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /app_teams/1 or /app_teams/1.json
  def update
    respond_to do |format|
      if @app_team.update(app_team_params)
        format.html { redirect_to app_team_url(@app_team), notice: 'App team was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_teams/1 or /app_teams/1.json
  def destroy
    @app_team.destroy

    respond_to do |format|
      format.html { redirect_to app_teams_url, notice: 'App team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_app_team
    @app_team = AppTeam.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def app_team_params
    params.require(:app_team).permit(:business_id, :app_id, :user_id, :added_by)
  end
end
