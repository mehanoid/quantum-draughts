# frozen_string_literal: true

module Game
  module Gameplay
    # successively performs all MoveStep's, transforming board
    class Move
      include Memery

      attr_reader :current_player, :board, :move_cells, :error

      # @param board [Game::Gameplay::Board] initial board
      # @param move_cells [Array<String>]
      def initialize(board, move_cells, current_player = nil)
        @board          = board
        @move_cells     = move_cells
        @current_player = current_player
      end

      # @return [Game::Gameplay::Board] transformed board
      def perform
        result || raise(error)
      end

      memoize def valid?
        result.present?
      end

      def beat?
        should_beat?
      end

      private

        memoize def result
          result_board, beaten_cells = move_cells.each_cons(2).reduce([board, []], &method(:perform_step))
          validate_final_state!(result_board, beaten_cells, move_cells.last)
          result_board
        rescue InvalidMove => e
          @error = e
          nil
        end

        def perform_step((board, prev_beaten_cells), step_cells)
          step = MoveStep.build(board, step_cells, current_player, prev_beaten_cells: prev_beaten_cells)
          validate_step!(step)
          [step.perform, step.beaten_cells]
        end

        def validate_step!(step)
          raise InvalidMove, 'move step should beat' unless !should_beat? || step.beat?
        end

        def validate_final_state!(board, beaten_cells, cell)
          moves_calculator = MovesCalculator.new(board, cell, current_player, prev_beaten_cells: beaten_cells)
          raise InvalidMove, 'can not stop if can beat' if should_beat? && moves_calculator.can_beat?
        end

        memoize def should_beat?
          MovesCalculator.new(board, move_cells.first, current_player).any_can_beat?
        end
    end
  end
end
