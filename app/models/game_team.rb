# frozen_string_literal: true

class GameTeam < ApplicationRecord
  belongs_to :game
  belongs_to :team

  enum :role, %i[home away officiating field_setup field_teardown]
end
