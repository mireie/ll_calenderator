# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_admin

  def index; end

  def refresh_all
    SyncAllOrganizationsJob.perform_later
    redirect_to admin_path, notice: I18n.t("admin.refresh_all.success")
  end

  private

  def authenticate_admin
    redirect_to root_path unless current_user.super?
  end
end
