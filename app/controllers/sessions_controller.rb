# frozen_string_literal: true

class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: lambda {
                                                               redirect_to new_session_url, alert: "Try again later."
                                                             }

  def new
    redirect_to root_path if authenticated?
  end

  def create
    if (user = User.authenticate_by(params.permit(:email_address, :password)))
      start_new_session_for user
      redirect_to after_authentication_url, notice: t(".success")
    else
      redirect_to new_session_path, alert: t(".failure")
    end
  end

  def destroy
    authenticated?&.destroy
    redirect_to new_session_path, alert: t(".success")
  end
end
