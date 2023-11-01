# frozen_string_literal: true

module Game
  module Matches
    class Join < ApplicationInteractor
      option :match
      option :player

      def call
        return Failure([:already_participates, 'Already participates']) if player.in?(match.players)

        match.update black_player: player
        match.start!
        MatchChannel.broadcast_with(match)

        Success()
      end
    end
  end
end
