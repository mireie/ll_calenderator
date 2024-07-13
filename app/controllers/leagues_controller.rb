# frozen_string_literal: true

# This is the controller for the League model.
class LeaguesController < ApplicationController
  before_action :set_league, only: %i[show edit update destroy webcal]
  skip_before_action :authenticate_user!, only: %i[index show webcal]

  # GET /leagues or /leagues.json
  def index
    @leagues = active_leagues
    @leagues = League.order(:start_date)
    @sports = League.distinct.pluck(:sport)
    @days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

    process_request
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("filter", partial: "filter", locals: { leagues: @leagues })
      end
      format.html
    end
  end

  # GET /leagues/1 or /leagues/1.json
  def show
    @current_user = current_user
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

    respond_to do |format|
      if @league.save
        format.html { redirect_to league_url(@league), notice: t(".success") }
        format.json { render :show, status: :created, location: @league }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leagues/1 or /leagues/1.json
  def update
    respond_to do |format|
      if @league.update(league_params)
        format.html { redirect_to league_url(@league), notice: t(".success") }
        format.json { render :show, status: :ok, location: @league }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1 or /leagues/1.json
  def destroy
    @league.destroy

    respond_to do |format|
      format.html { redirect_to leagues_url, notice: t(".success") }
      format.json { head :no_content }
    end
  end

  def webcal
    send_data(
      @league.games_to_ical,
      filename: "#{@league.external_id}.ics",
      type: "text/calendar",
      disposition: "attachment"
    )
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
    # leagues that have games in the future of if the league has no games, the start date is in the future
    League.joins(:games)
      .where(games: { start_time: Time.zone.now.. })
      .or(League.where("games.start_time IS NULL AND leagues.start_date >= ?", Time.zone.now))
      .distinct
  end
end
