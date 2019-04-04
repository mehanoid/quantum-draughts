# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :gon_defaults

  private

  def gon_defaults
    return unless request.format.html?

    gon.current_user = UserSerializer.new(current_user).as_json if user_signed_in?
  end
end
