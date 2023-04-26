# frozen_string_literal: true

class ApplicationController < ActionController::API
  # When required parameters are missing, strong params will throw an exception.
  #  Catch it here and send :bad_request (400) to client
  rescue_from ActionController::ParameterMissing do
    render nothing: true, status: :bad_request
  end
end
