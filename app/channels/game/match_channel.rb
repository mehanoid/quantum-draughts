# frozen_string_literal: true

module Game
  class MatchChannel < ApplicationCable::Channel
    class << self
      def broadcast_with(match)
        broadcast_to(match, serialize(match, serializer: Game::MatchDetailsSerializer))
      end
    end

    def subscribed
      match = Match.find(params[:id])
      stream_for match
    end

    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end
  end
end
