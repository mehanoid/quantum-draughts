class ProfilesController < ApplicationController
  def update
    current_or_guest_user.update!(user_params)

    render json: current_or_guest_user
  end

  private

    def user_params
      params[:user]&.permit(:displaying_name) || {}
    end
end
