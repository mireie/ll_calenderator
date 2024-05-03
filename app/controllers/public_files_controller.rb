# app/controllers/public_files_controller.rb
class PublicFilesController < ApplicationController
  def index
    @files = Dir.glob("public/**/*.ics")
    @files = []
    Dir.glob("public/**/*.ics").each do |file|
      team_id = file.split("/")[-1].split(".")[0]
      team = Team.find_by(external_id: team_id)
      @files << {
        team_id:,
        team_name: team.name,
        league_name: team.league.title,
        path: file
      }
    end
  end
end
