# frozen_string_literal: true

module Game
  class MatchDetailsSerializer < MatchSerializer
    attributes :boards, :possible_moves

    has_many :match_turns

    def boards
      object.board_instances.map(&:as_json)
    end

    def match_turns
      object.match_turns.order(:id).select(:id, :turn_number, :player, :move)
    end

    def possible_moves
      Gameplay::QuantumMovesCalculator.valid_possible_move_chains(
        object.board_instances,
        object.current_player_color.to_sym,
        ruleset: object.ruleset_object,
      )
    end

  end
end
