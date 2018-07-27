# frozen_string_literal: true

module Game
  class MatchTurnsController < ApplicationController
    def show
      match_turn = MatchTurn.find params[:id]
      render json: MatchTurnDetailsSerializer.new(match_turn).as_json
    end
  end
end
