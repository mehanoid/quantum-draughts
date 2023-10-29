# frozen_string_literal: true

module Game
  class MatchesController < ApplicationController
    def index
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json do
          matches = Match.active
                         .where(updated_at: 1.day.ago..)
                         .order(:state, updated_at: :desc)
                         .includes(:white_player, :black_player)

          user = current_or_guest_user(create: false)
          current_user_matches =
            if user
              Match.by_player(user)
                   .order(:state, updated_at: :desc)
                   .includes(:white_player, :black_player)
            else
              []
            end

          render json: {
            all_matches:          serialize(matches),
            current_user_matches: serialize(current_user_matches),
          }
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

      current_or_guest_user.update!(user_params) if user_params[:displaying_name]

      render json: { id: match.id }
    end

    def move
      user = current_or_guest_user(create: false)

      match.with_lock do
        unless user == match.current_player
          render json: { status: :error }, status: :forbidden
          raise ActiveRecord::Rollback
        end

        case Game::Matches::MakeMove.call(current_user: user, match:, moves: params[:moves])
        in Success()
          render json: { status: :ok }
        in Failure(message)
          render json: { status: :error, error: "Invalid move: #{message}" }
        end
      end
    end

    def join
      raise 'Already participates' if current_or_guest_user.in?(match.players)

      match.update black_player: current_or_guest_user
      match.start!
      MatchChannel.broadcast_with(match)
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

    def user_params
      params.fetch(:user, {}).permit(:displaying_name)
    end
  end
end
