# frozen_string_literal: true

module Gameplay
  class BoardMovesCalculator
    include Memery

    attr_reader :board, :current_player, :ruleset

    # @param board [Gameplay::Types::Board]
    # @param current_player [Symbol]
    def initialize(board, current_player, ruleset:)
      @board          = board
      @current_player = current_player
      @ruleset        = ruleset
    end

    def all_beat_move_steps
      all_possible_move_steps.select(&:beat?)
    end

    def any_can_beat?
      all_possible_move_steps.any?(&:beat?)
    end

    def all_possible_move_steps
      from_cells = board.occupied_cells.select { |c| c.draught.color == current_player }
      from_cells.flat_map do |cell|
        MovesCalculator.new(board, cell.name, current_player, ruleset: ruleset).possible_move_steps
      end
    end

    def all_possible_move_chains
      from_cells = board.occupied_cells.select { |c| c.draught.color == current_player }
      from_cells.flat_map do |cell|
        MovesCalculator.new(board, cell.name, current_player, ruleset: ruleset).possible_move_chains
      end
    end
  end
end
