# frozen_string_literal: true

class JobsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate

  def sync_games
    NightlySyncJob.perform_async
    render json: { message: "NightlySyncJob enqueued" }, status: :ok
  end

  def sync_leagues
    SyncLeaguesJob.perform_async
    render json: { message: "SyncLeaguesJob enqueued" }, status: :ok
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(token),
        ::Digest::SHA256.hexdigest(Rails.application.credentials.sync_leagues_token)
      )
    end
  end
end
