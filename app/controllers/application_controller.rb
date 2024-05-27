# frozen_string_literal: true

# The ApplicationController is the parent class for all controllers in the application
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!
end
