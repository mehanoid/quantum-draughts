# frozen_string_literal: true

module Game
  class MatchesController < ApplicationController
    def index
      respond_to do |format|
        format.html
        format.json do
          matches = Match.order(:state, id: :desc).includes(:white_player, :black_player)
          render json: matches
        end
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json do
          render json: match, serializer: MatchDetailsSerializer
        end
      end
    end

    def create
      Game::Match.order(:id).offset(30).destroy_all
      match = Match.create_initial_match match_params.merge(white_player: current_or_guest_user)

      render json: { id: match.id }
    end

    def move
      match.with_lock do
        unless current_or_guest_user == match.current_player
          return render json: { status: :error }, status: :forbidden
        end

        result = Gameplay.move match.current_turn, params[:moves], match.ruleset_object
        match.current_turn.update move: result[:move]
        match.match_turns.create! result[:next_turn]
        MatchChannel.broadcast_to(match, serialize(match, serializer: MatchDetailsSerializer))
        render json: { status: :ok }
      end
    rescue Gameplay::InvalidMove => e
      render json: { status: :error, error: "Invalid move: #{e.message}" }
    end

    def join
      raise 'Already participates' if current_or_guest_user.in?(match.players)

      match.update black_player: current_or_guest_user
      match.start!
      MatchChannel.broadcast_to(match, serialize(match, serializer: MatchDetailsSerializer))
      render json: { status: :ok }
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
