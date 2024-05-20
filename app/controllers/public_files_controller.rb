# frozen_string_literal: true

# The PublicFilesController is responsible for handling requests for public files
class PublicFilesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    process_request

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("filter", partial: "filter", locals: { files: @files })
      end
      format.html
    end
  end

  private

  def process_request
    @files = ical_files.map { |file| file_attributes(file) }
    filter_files
  end

  def ical_files
    Dir.glob("public/**/*.ics")
  end

  def file_attributes(file)
    team = Team.find_by(external_id: team_id_from_path(file))
    league = League.find_by(external_id: league_id_from_path(file))
    {
      team_id: team&.external_id,
      team_name: team&.name,
      league_name: league&.title,
      path: file,
    }
  end

  def filter_files
    return if public_file_params[:team_name].blank?

    @files = @files.select do |file|
      file[:team_name]&.downcase&.include?(public_file_params[:team_name].downcase)
    end
  end

  def league_id_from_path(path)
    path.split("/")[-2]
  end

  def team_id_from_path(path)
    path.split("/")[-1].split(".")[0]
  end

  def public_file_params
    params.permit(:team_name)
  end
end
