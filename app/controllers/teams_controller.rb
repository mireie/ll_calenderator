# frozen_string_literal: true

# This is the controller for the Team model.
class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy webcal]
  skip_before_action :authenticate_user!, only: %i[index show webcal]

  # GET /teams or /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1 or /teams/1.json
  def show; end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit; end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to team_url(@team), notice: t(".success") }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to team_url(@team), notice: t(".success") }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url, notice: t(".success") }
      format.json { head :no_content }
    end
  end

  def webcal
    @team.team_webcal_logs.create!(
      ip_address: request.ip,
      user_agent: request.user_agent
    )

    send_data(
      @team.games_to_ical,
      filename: "#{@team.external_id}.ics",
      type: "text/calendar",
      disposition: "attachment"
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def team_params
    params.fetch(:team, {})
  end
end
