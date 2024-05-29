# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_admin

  def index; end

  def refresh_all
    League.find_each do |league|
      # TODO: Temporary fix until I can figure out why Sidekiq isn't working
      PullLeagueScheduleDataJob.new.perform(league.id)
      PullLeagueTeamsDataJob.new.perform(league.id)
    end

    redirect_to admin_path, notice: "Refresh jobs queued"
  end

  private

  def authenticate_admin
    redirect_to root_path unless current_user.super?
  end
end
