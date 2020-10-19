# frozen_string_literal: true

module Gameplay
  class << self
    def move(match_turn, moves_params, ruleset)
      move = Gameplay::QuantumMove.new(
        match_turn.board_instances,
        moves_params,
        match_turn.player.to_sym,
        ruleset: ruleset,
      )

      player = next_player(match_turn)

      {
        next_turn: {
          boards:      Gameplay::Serialization::JsonExport.new(move.perform).as_json,
          player:      player,
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
      match_turn.white? ? :black : :white
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
