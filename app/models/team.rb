# frozen_string_literal: true

# The Team model represents a team in the system
class Team < ApplicationRecord
  belongs_to :league
  has_one :organization, through: :league
  has_many :game_teams, dependent: :destroy
  has_many :games, through: :game_teams

  def games
    Game.where("home_team_id = ? OR away_team_id = ?", id, id)
  end

  def games_to_ical
    TeamCalendar.new(self).to_ical
  end
end
