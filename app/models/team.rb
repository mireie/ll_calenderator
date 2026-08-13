# frozen_string_literal: true

# The Team model represents a team in the system
class Team < ApplicationRecord
  belongs_to :league
  has_one :organization, through: :league
  has_many :game_teams, dependent: :destroy
  has_many :games, through: :game_teams
  has_many :team_webcal_logs, dependent: :destroy

  scope :ordered, -> { order(:name) }

  def games
    game_teams.includes(:game).map do |game_team|
      { game: game_team.game, role: game_team.role }
    end
  end

  def games_to_ical
    TeamCalendar.new(self).to_ical
  end
end
