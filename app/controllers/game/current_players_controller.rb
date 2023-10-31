# frozen_string_literal: true

module Game
  class CurrentPlayersController < BaseController
    before_action :create_player_if_absent, only: %i[update]

    def show
      render json: current_player
    end

    def update
      current_player.update!(player_params)

      render json: current_player
    end

    private

    def player_params
      params.fetch(:player, {}).permit(:displaying_name)
    end
  end
end
