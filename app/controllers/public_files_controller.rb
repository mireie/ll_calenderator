# frozen_string_literal: true

class PublicFilesController < ApplicationController
  def index
    @files = get_files
    # fuzzy search
    return @files unless params[:team_name].present?

    @files = @files.select { |file| file[:team_name].downcase.include?(params[:team_name].downcase) }
  end

  private

  def get_files
    files = []

    Dir.glob("public/**/*.ics").each do |file|
      team_id = file.split("/")[-1].split(".")[0]
      league_id = file.split("/")[-2]
      if team_id == "games"
        next unless League.find_by(external_id: league_id)

        files << {
          team_id: nil,
          team_name: "All Games",
          league_name: League.find_by(external_id: league_id).title,
          path: file
        }
      else
        team = Team.find_by(external_id: team_id)
        next unless team

        files << {
          team_id:,
          team_name: team.name,
          league_name: team.league.title,
          path: file
        }
      end
    end
    files
  end
end
