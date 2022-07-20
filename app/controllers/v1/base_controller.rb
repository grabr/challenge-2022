module V1
  class BaseController < ApplicationController
    protected

    def current_user
      User.first
    end
  end
end
