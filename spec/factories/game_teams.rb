# frozen_string_literal: true

FactoryBot.define do
  factory :game_team do
    game { nil }
    team { nil }
    role { 1 }
  end
end
