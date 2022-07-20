class ApplicationController < ActionController::API
  class NotAuthenticated < StandardError; end

  rescue_from NotAuthenticated, with: -> { head(401) }
end
