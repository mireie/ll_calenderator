# frozen_string_literal: true

# This is the mailer for the application.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
