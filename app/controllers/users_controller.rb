# frozen_string_literal: true

class UsersController < ApplicationController
  def current
    render json: current_user
  end
end
