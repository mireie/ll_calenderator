class TeamWebcalLog < ApplicationRecord
  belongs_to :team

  def self.hits_by_team
    joins(:team)
      .select("teams.id AS team_id, teams.name AS team_name, COUNT(team_webcal_logs.id) AS hit_count")
      .group("teams.id, teams.name")
      .order("hit_count DESC, teams.name ASC")
  end

  def self.daily_hits
    group("DATE(created_at)").order("DATE(created_at) ASC").count
  end
end
