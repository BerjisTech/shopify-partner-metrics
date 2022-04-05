# frozen_string_literal: true

class AppTeamsController < ApplicationController
  before_action :set_app_team, only: %i[show edit update destroy]

  # GET /app_teams or /app_teams.json
  def index
    @app_teams = AppTeam.all
  end

  # GET /app_teams/1 or /app_teams/1.json
  def show; end

  # GET /app_teams/new
  def new
    @app_team = AppTeam.new
  end

  # GET /app_teams/1/edit
  def edit; end

  # POST /app_teams or /app_teams.json
  def create
    @app_team = AppTeam.new(app_team_params)

    respond_to do |format|
      if @app_team.save
        format.html { redirect_to app_team_url(@app_team), notice: 'App team was successfully created.' }
        format.json { render :show, status: :created, location: @app_team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_team.errors, status: :unprocessable_entity }
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
