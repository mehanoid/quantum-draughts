# frozen_string_literal: true

module Game
  class MatchesController < ApplicationController
    def index
      gon.matches = Match.order(id: :desc).as_json(only: %i[id])
    end

    def show
      gon.match = MatchSerializer.new(match).as_json
    end

    def create
      Game::Match.order(:id).offset(30).destroy_all
      match = Match.create_initial_match match_params

      render json: { id: match.id }
    end
    #
    # def destroy
    #   match.destroy
    #   respond_to do |format|
    #     format.html { redirect_to game_matches_url, notice: 'Match was successfully destroyed.' }
    #     format.json { head :no_content }
    #   end
    # end

    def move
      match.with_lock do
        result = Gameplay.move match.current_turn, params[:moves], match.ruleset_object
        match.current_turn.update move: result[:move]
        match.match_turns.create! result[:next_turn]
        MatchChannel.broadcast_to(match, MatchSerializer.new(match).as_json)
        render json: { status: :ok }
      end
    rescue Gameplay::InvalidMove => e
      render json: { status: :error, error: "Invalid move: #{e.message}" }
    end

    private

      helper_method def match
        @match ||= Match.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def match_params
        params.require(:game_match).permit(:ruleset)
      end
  end
end
