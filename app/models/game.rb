class Game < ApplicationRecord
  belongs_to :league
  has_one :location
end
