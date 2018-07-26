# frozen_string_literal: true

module Game
  class MatchesController < ApplicationController
    def index
      @matches = Match.all
    end

    def show
      gon.match = MatchSerializer.new(match).as_json
    end

    def new
      @match = Match.new
    end

    def create
      @match = Match.create_initial_match

      redirect_to @match, notice: 'Match was successfully created.'
    end

    def destroy
      match.destroy
      respond_to do |format|
        format.html { redirect_to game_matches_url, notice: 'Match was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    def move
      game = Game::Gameplay.new(match.current_turn)
      match.match_turns.create! game.move params[:moves]
      render json: { match: MatchSerializer.new(match).as_json }
    rescue Game::InvalidMove => e
      render json: { match: MatchSerializer.new(match).as_json, error: "Invalid move: #{e.message}" }
    end

    private

      helper_method def match
        @match ||= Match.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def match_params
        param  = params.require(:match).permit(:boards)
        boards = JSON.parse param[:boards]
        param.merge(boards: boards)
      end
  end
end
