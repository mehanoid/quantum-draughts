# frozen_string_literal: true

module Game
  class BaseController < ApplicationController
    private

    def current_player
      @current_player ||=
        if user_signed_in?
          Player.find_or_create_by(user: current_user)
        else
          uuid = session[:game_player_uuid]
          Player.find_by(uuid:) if uuid
        end
    end

    def create_player_if_absent
      return if current_player

      @current_player = Player.create.tap do |player|
        session[:game_player_uuid] = player.uuid
      end
    end
  end
end
