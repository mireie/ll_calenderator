# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_admin

  def index
    @team_webcal_stats = TeamWebcalLog.hits_by_team
    @daily_webcal_hits = TeamWebcalLog.daily_hits
    @total_webcal_hits = TeamWebcalLog.count
  end

  def refresh_all
    NightlySyncJob.perform_later
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = I18n.t("admin.refresh_all.success")
        render turbo_stream: [
          turbo_stream.replace("flash", partial: "layouts/flash"),
          turbo_stream.replace("refresh_all", partial: "admin/refresh_all")
        ]
      end
      format.html do
        redirect_to admin_path, notice: I18n.t("admin.refresh_all.success")
      end
    end
  end

  private

  def authenticate_admin
    redirect_to root_path unless current_user.super?
  end
end
