# frozen_string_literal: true

module Game
  module Matches
    class Create < ApplicationInteractor
      option :player
      option :params

      def call
        match = ActiveRecord::Base.transaction do
          yield update_player
          yield create_match
        end

        Success(match)
      end

      private

      def update_player
        return Success() unless player_params[:displaying_name]

        return Success() if player.update(player_params)

        Failure([:invalid_player, player.errors.full_messages.to_sentence])
      end

      def create_match
        match = Match.create_initial_match match_params.merge(white_player: player)
        if match.valid?
          Success(match)
        else
          Failure([:invalid_match, match.errors.full_messages.to_sentence])
        end
      end

      def match_params
        params.require(:game_match).permit(:ruleset)
      end

      def player_params
        params.fetch(:player, {}).permit(:displaying_name)
      end
    end
  end
end
