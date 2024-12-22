# frozen_string_literal: true

# The ApplicationController is the parent class for all controllers in the application
class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
end
