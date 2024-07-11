# frozen_string_literal: true

# The Game model represents a game in the system
class Game < ApplicationRecord
  belongs_to :league
  belongs_to :location, optional: true
  has_one :organization, through: :league
  has_many :game_teams, dependent: :destroy
  has_many :teams, through: :game_teams

  DEFAULT_DURATION = 60

  enum status: { scheduled: 0, in_progress: 1, completed: 2, removed: 3 }

  def end_time
    start_time + (league.duration || DEFAULT_DURATION).minutes
  end

  def home_team
    game_teams.find_by(role: :home)&.team
  end

  def away_team
    game_teams.find_by(role: :away)&.team
  end

  def officiating_team
    game_teams.find_by(role: :officiating)&.team
  end

  def to_ical
    IcalEventService.new.create_event_from_game(self)
  end
end
