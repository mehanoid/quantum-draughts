# frozen_string_literal: true

module Game
  module Gameplay
    class MovesCalculator
      include Memery

      attr_reader :board, :cell_name, :current_player, :prev_beaten_cells

      # @param board [Game::Gameplay::Board]
      # @param cell_name [String]
      # @param current_player [Symbol]
      # @param should_beat [Boolean]
      def initialize(board, cell_name, current_player, should_beat: nil, prev_beaten_cells: [])
        @board          = board
        @cell_name      = cell_name
        @current_player = current_player
        @should_beat    = should_beat
        @prev_beaten_cells = prev_beaten_cells
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
        length = MoveStep.max_length(from_cell)
        board.diagonals_through_cell(from_cell, length).map do |cell|
          MoveStep.build(board, [cell_name, cell.name], current_player, prev_beaten_cells: prev_beaten_cells)
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
              should_beat: true,
              prev_beaten_cells: move_step.beaten_cells
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
        @should_beat || self.class.any_can_beat?(board, current_player)
      end

      def from_cell
        board.cell_at(cell_name)
      end

      class << self
        def all_beat_move_steps(board, player)
          all_possible_move_steps(board, player).select(&:beat?)
        end

        def any_can_beat?(board, player)
          all_possible_move_steps(board, player).any?(&:beat?)
        end

        def all_possible_move_steps(board, player)
          from_cells = board.occupied_cells.select { |c| c.draught.color == player }
          from_cells.flat_map do |cell|
            new(board, cell.name, player).possible_move_steps
          end
        end

        def all_possible_move_chains(board, player)
          from_cells = board.occupied_cells.select { |c| c.draught.color == player }
          from_cells.flat_map do |cell|
            new(board, cell.name, player).possible_move_chains
          end
        end
      end

      private

        def valid_move?(move_step)
          move_step.valid? && (!any_can_beat? || move_step.beat?)
        end
    end
  end
end
