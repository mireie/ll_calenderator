# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_teams, dependent: :destroy
  has_many :teams, through: :user_teams

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }
end
