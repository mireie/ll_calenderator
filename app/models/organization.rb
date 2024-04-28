class Organization < ApplicationRecord
  has_many :leagues
  has_many :teams, through: :leagues
  has_many :games, through: :leagues
  has_many :locations
end
