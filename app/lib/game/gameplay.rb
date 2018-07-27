# frozen_string_literal: true

module Game
  module Gameplay
    class << self
      def move(match_turn, moves_params)
        move = Game::Gameplay::QuantumMove.new(match_turn.board_instances, moves_params, match_turn.player.to_sym)

        {
          next_turn: {
            boards:      Game::Gameplay::Board::JsonExport.new(move.perform).as_json,
            player:      next_player(match_turn),
            turn_number: next_turn(match_turn),
          },
          move:      last_move(move, moves_params),
        }
      end

      private

        def next_turn(match_turn)
          match_turn.player == 'white' ? match_turn.turn_number : match_turn.turn_number + 1
        end

        def next_player(match_turn)
          match_turn.player == 'white' ? 'black' : 'white'
        end

        def last_move(move, moves_params)
          moves_params.map do |cells|
            {
              beat:  move.beat?,
              cells: cells,
            }
          end
        end
    end
  end
end