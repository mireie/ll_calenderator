# frozen_string_literal: true

class GameTeam < ApplicationRecord
  belongs_to :game
  belongs_to :team

  enum role: { home: 0, away: 1, official: 2, field_setup: 3, field_teardown: 4 }
end
