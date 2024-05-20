# frozen_string_literal: true

class PublicFilesController < ApplicationController
  def index
    @files = get_files
    # fuzzy search

    if params[:team_name].present?
      @files = @files.select { |file| file[:team_name].downcase.include?(params[:team_name].downcase) }
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("filter", partial: "filter", locals: { files: @files })
      end
      format.html
    end
  end

  private

  def get_files
    files = []

    Dir.glob("public/**/*.ics").each do |file|
      team_id = file.split("/")[-1].split(".")[0]
      league_id = file.split("/")[-2]
      team = Team.find_by(external_id: team_id)
      if team
        files << {
          team_id: team.external_id,
          team_name: team.name,
          league_name: team.league.title,
          path: file
        }
        next
      end

      next unless team_id == "games"
      next unless League.find_by(external_id: league_id)

      files << {
        team_id: nil,
        team_name: "All Games",
        league_name: League.find_by(external_id: league_id).title,
        path: file
      }
    end
    files
  end
end
