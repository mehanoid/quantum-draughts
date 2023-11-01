# frozen_string_literal: true

module Game
  class MatchesController < BaseController
    before_action :create_player_if_absent, only: %i[create join]

    def index
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json do
          matches = Match.order(:state, updated_at: :desc).includes(:white_player, :black_player)
          current_matches = matches.current
          current_player_matches = current_player ? matches.by_player(current_player) : []

          render json: {
            current_matches:        serialize(current_matches),
            current_player_matches: serialize(current_player_matches),
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
      case Matches::Create.call(player: current_player, params:)
      in Success(match)
        render json: { id: match.id }
      in Failure(code, detail)
        render_json_error(code:, detail:)
      end
    end

    def move
      case Matches::MakeMove.call(current_player:, match:, moves: params[:moves])
      in Success()
        head :ok
      in Failure(:out_of_turn)
        head :forbidden
      in Failure(code, detail)
        render_json_error(code:, detail:)
      end
    end

    def join
      case Game::Matches::Join.call(match:, player: current_player)
      in Success
        head :ok
      in Failure(code, detail)
        render_json_error(code:, detail:)
      end
    end

    private

    helper_method def match
      @match ||= Match.find(params[:id])
    end
  end
end
