# frozen_string_literal: true

# The Game model represents a game in the system
class Game < ApplicationRecord
  belongs_to :league
  belongs_to :location, optional: true
  has_one :organization, through: :league
  has_many :game_teams, dependent: :destroy
  has_many :teams, through: :game_teams

  DEFAULT_DURATION = 60

  enum :status, %i[scheduled in_progress completed removed]

  default_scope { where.not(status: :removed) }

  def end_time
    start_time + (league.duration || DEFAULT_DURATION).minutes
  end

  def home_team
    game_teams.detect { |gt| gt.role == "home" }&.team
  end

  def away_team
    game_teams.detect { |gt| gt.role == "away" }&.team
  end

  def officiating_team
    game_teams.detect { |gt| gt.role == "officiating" }&.team
  end

  def to_ical(role = nil)
    IcalEventService.new.create_event_from_game(self, role)
  end
end
