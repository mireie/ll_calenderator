# frozen_string_literal: true

# The Organization model is responsible for the top-level organization that is responsible for the
# leagues, teams, and games
class Organization < ApplicationRecord
  has_many :leagues
  has_many :teams, through: :leagues
  has_many :games, through: :leagues
  has_many :locations
end
