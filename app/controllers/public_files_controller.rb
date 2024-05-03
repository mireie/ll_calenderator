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
      team = Team.find_by(external_id: team_id)
      files << {
        team_id:,
        team_name: team.name,
        league_name: team.league.title,
        path: file
      }
    end
    files
  end
end
