# frozen_string_literal: true

class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    redirect_to root_path if authenticated?
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    begin
      if @user.save
        start_new_session_for @user
        redirect_to root_path, notice: t(".success")
      else
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      flash.now[:alert] = t(".email_taken", sign_in_path: new_session_path).html_safe
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
