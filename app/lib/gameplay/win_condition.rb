# frozen_string_literal: true

module Gameplay
  class WinCondition
    attr_reader :current_player, :boards, :ruleset

    # @param boards [Array<Gameplay::Board>]
    # @param [Symbol] current_player
    # @param [Object] ruleset
    def initialize(boards, current_player = nil, ruleset:)
      @boards         = boards
      @current_player = current_player
      @ruleset        = ruleset
    end

    def perform
      possible_next_moves = Gameplay::QuantumMovesCalculator.valid_possible_move_chains(
        boards,
        current_player,
        ruleset: ruleset,
      )

      if possible_next_moves.blank?
        {
          finished: true,
          winner:   winner
        }
      else
        {
          finished: false,
          winner:   nil
        }
      end
    end

    def winner
      current_player.to_sym == :white? ? :black : :white
    end
  end
end
