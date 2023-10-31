# frozen_string_literal: true

module Game
  class MatchesController < BaseController
    before_action :create_player_if_absent, only: %i[create join]

    def index
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json do
          matches = Match.active
                         .where(updated_at: 1.day.ago..)
                         .order(:state, updated_at: :desc)
                         .includes(:white_player, :black_player)

          player = current_player
          current_user_matches =
            if player
              Match.by_player(player)
                   .order(:state, updated_at: :desc)
                   .includes(:white_player, :black_player)
            else
              []
            end

          render json: {
            all_matches:            serialize(matches),
            current_player_matches: serialize(current_user_matches),
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
      match = Match.create_initial_match match_params.merge(white_player: current_player)

      current_player.update!(player_params) if player_params[:displaying_name]

      render json: { id: match.id }
    end

    def move
      match.with_lock do
        unless current_player == match.current_player
          render json: { status: :error }, status: :forbidden
          raise ActiveRecord::Rollback
        end

        case Game::Matches::MakeMove.call(current_user: current_player, match:, moves: params[:moves])
        in Success()
          render json: { status: :ok }
        in Failure(message)
          render json: { status: :error, error: "Invalid move: #{message}" }
        end
      end
    end

    def join
      raise 'Already participates' if current_player.in?(match.players)

      match.update black_player: current_player
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

    def player_params
      params.fetch(:player, {}).permit(:displaying_name)
    end
  end
end
