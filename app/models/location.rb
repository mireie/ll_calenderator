# frozen_string_literal: true

class Location < ApplicationRecord
  # geocoded_by :address
  # after_validation :geocode, if: ->(obj) { !obj.verified && obj.address.present? && obj.address_changed? }

  has_many :games, dependent: :nullify
  has_many :teams, through: :games

  def verified!
    update(verified: true)
  end
end
