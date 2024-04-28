class Team < ApplicationRecord
  belongs_to :league
  belongs_to :organization, through: :league
end
