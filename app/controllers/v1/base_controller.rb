module V1
  class BaseController < ApplicationController
    before_action :set_current_user

    protected

    attr_reader :current_user

    def set_current_user
      @current_user ||= ActionDispatch::Http::Headers.from_hash(request.headers)['Auth-User-Id']
        .then { |id| id ? User.find(id) : raise(NotAuthenticated) }
    end
  end
end
