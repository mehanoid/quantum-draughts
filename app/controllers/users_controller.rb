class UsersController < ApplicationController
  def current
    render json: current_or_guest_user(create: false)
  end
end