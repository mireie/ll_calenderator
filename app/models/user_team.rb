# frozen_string_literal: true

class UserTeam < ApplicationRecord
  belongs_to :user
  belongs_to :team
end
