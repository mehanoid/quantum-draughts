# frozen_string_literal: true

module Gameplay
  class MovesCalculator
    include Memery

    attr_reader :board, :cell_name, :current_player, :prev_beaten_cells, :ruleset

    # @param board [Gameplay::Types::Board]
    # @param cell_name [String]
    # @param current_player [Symbol]
    # @param should_beat [Boolean]
    def initialize(board, cell_name, current_player, should_beat: nil,
                   prev_beaten_cells: [], ruleset:)
      @board             = board
      @cell_name         = cell_name
      @current_player    = current_player
      @should_beat       = should_beat
      @prev_beaten_cells = prev_beaten_cells
      @ruleset           = ruleset
    end

    # @return [Array<String>]
    def possible_moves
      valid_move_steps.map { |step| step.to_cell.name }
    end

    def possible_move_chains
      valid_move_steps.flat_map { |step| possible_next_steps(step) }
    end

    def possible_move_chains_cell_names
      possible_move_chains.map { |chain| chain.map { |m| m.to_cell.name } }
    end

    def can_beat?
      possible_move_steps.any?(&:beat?)
    end

    def beat_move_steps
      possible_move_steps.select(&:beat?)
    end

    def possible_move_steps
      length = ruleset.max_step_length(from_cell)
      board.diagonals_through_cell(from_cell, length).map do |cell|
        ruleset.build_move_step(board, [cell_name, cell.name], current_player, prev_beaten_cells: prev_beaten_cells)
      end.select(&:valid?)
    end

    def valid_move_steps
      possible_move_steps.select(&method(:valid_move?))
    end

    def possible_next_steps(move_step)
      next_steps_groups =
        if any_can_beat?
          possible_next_moves_obj = self.class.new(
            move_step.perform,
            move_step.to_cell.name,
            current_player,
            should_beat:       true,
            prev_beaten_cells: move_step.beaten_cells,
            ruleset:           ruleset,
          )
          possible_next_moves_obj.valid_move_steps.flat_map do |next_step|
            possible_next_moves_obj.possible_next_steps(next_step)
          end
        else
          []
        end
      if next_steps_groups.present?
        next_steps_groups.map { |next_steps_group| [move_step, *next_steps_group] }
      else
        [[move_step]]
      end
    end

    memoize def any_can_beat?
      # TODO не вызывать BoardMovesCalculator из MovesCalculator
      @should_beat || BoardMovesCalculator.new(board, current_player, ruleset: ruleset).any_can_beat?
    end

    def from_cell
      board.cell_at(cell_name)
    end

    private

      def valid_move?(move_step)
        move_step.valid? && (!any_can_beat? || move_step.beat?)
      end
  end
end
