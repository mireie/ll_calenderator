# frozen_string_literal: true

# This is the controller for the League model.
class LeaguesController < ApplicationController
  before_action :set_league, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[index show teams]

  # GET /leagues or /leagues.json
  def index
    @leagues = active_leagues.order(:start_date).includes(:organization)
    @sports = @leagues.map(&:sport).uniq
    @leagues_by_sport = @leagues.group_by(&:sport).transform_values do |leagues|
      leagues.sort_by(&:start_date)
    end
    @days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

    process_request
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /leagues/1 or /leagues/1.json
  def show
    @teams = @league.teams.ordered
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit; end

  # POST /leagues or /leagues.json
  def create
    @league = League.new(league_params)

    if @league.save
      respond_to do |format|
        format.html { redirect_to leagues_path, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /leagues/1 or /leagues/1.json
  def update
    if @league.update(league_params)
      respond_to do |format|
        format.html { redirect_to leagues_path, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /leagues/1 or /leagues/1.json
  def destroy
    @league.destroy

    respond_to do |format|
      format.html { redirect_to leagues_url, notice: t(".success") }
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  def teams
    @league = League.find(params[:id])
    @teams = @league.teams
    render partial: "leagues/teams", locals: { teams: @teams, league: @league }
  end

  private

  def filter_days
    return if league_params[:day].blank?

    @leagues = @leagues.select do |league|
      league.days&.any? { |day| league_params[:day].include?(day) }
    end
  end

  def filter_sports
    return if league_params[:sport].blank?

    @leagues = @leagues.select do |league|
      league.sport.downcase.include?(league_params[:sport].downcase)
    end
  end

  def process_request
    filter_sports
    filter_days
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_league
    @league = League.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def league_params
    params.permit(:sport, :day)
  end

  def active_leagues
    return League.all
    leagues = League.includes(:games).where(games: { start_time: Time.zone.now.. }).distinct
    return leagues if leagues.present?

    League.where(start_date: Time.zone.now..).distinct
  end
end
