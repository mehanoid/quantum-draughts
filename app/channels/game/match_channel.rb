# frozen_string_literal: true

class Game::MatchChannel < ApplicationCable::Channel
  def subscribed
    match = Game::Match.find(params[:id])
    stream_for match
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
