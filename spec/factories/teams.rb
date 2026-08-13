FactoryBot.define do
  factory :team do
    association :league
    name { "Test Team" }
    external_id { "team-#{rand(1_000_000)}" }
  end

  factory :team_webcal_log do
    team
    ip_address { "127.0.0.1" }
    user_agent { "Test Agent" }
  end
end
