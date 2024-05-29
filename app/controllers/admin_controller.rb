# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_admin

  def index; end

  def refresh_all
    League.find_each do |league|
      PullLeagueScheduleDataJob.perform_async(league.id)
      PullLeagueTeamsDataJob.perform_async(league.id)
    end

    redirect_to admin_path, notice: "Refresh jobs queued"
  end

  private

  def authenticate_admin
    redirect_to root_path unless current_user.super?
  end
end
