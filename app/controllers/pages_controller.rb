# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    render layout: "splash"
  end

  def calendar_discontinued
    render plain: "This calendar has been discontinued.", status: :gone
  end
end
