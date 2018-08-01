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

      def perform_partial
        last_valid_step = valid_steps.last
        last_valid_step&.perform || board
      end

      memoize def valid?
        result.present?
      end

      def beat?
        should_beat?
      end

      def valid_final_state?
        !should_beat? || next_moves_calculators.none?(&:can_beat?)
      end

      private

        memoize def result
          move_steps.each(&method(:validate_step!))
          validate_final_state!
          last_step.perform
        rescue InvalidMove => e
          @error = e
          nil
        end

        def validate_final_state!
          raise InvalidMove, 'can not stop if can beat' unless valid_final_state?
        end

        def valid_steps
          move_steps.take_while { |s| s.valid? && valid_step?(s) }
        end

        def next_moves_calculators
          [next_moves_calculator(last_step), *alternative_last_steps.map(&method(:next_moves_calculator))]
        end

        # @return [Game::Gameplay::MoveStep]
        def last_step
          move_steps.last
        end

        def alternative_last_steps
          moves_calculator(last_step).valid_move_steps.select(&method(:same_direction_as_last_step?))
        end

        def same_direction_as_last_step?(step)
          last_step.from_cell.same_direction?(step.to_cell, last_step.to_cell)
        end

        # @return [Array<Game::Gameplay::MoveStep>]
        memoize def move_steps
          move_cells.each_cons(2).reduce([], &method(:add_step))
        end

        # @return [Array<Game::Gameplay::MoveStep>]
        def add_step(steps, step_cells)
          prev_step = steps.last
          step = MoveStep.build(
            prev_step&.perform || board,
            step_cells,
            current_player,
            prev_beaten_cells: (prev_step&.beaten_cells || [])
          )
          [*steps, step]
        end

        def validate_step!(step)
          raise InvalidMove, 'move step should beat' unless valid_step?(step)
        end

        def valid_step?(step)
          !should_beat? || step.beat?
        end

        def moves_calculator(step)
          MovesCalculator.new(step.board, step.from_cell.name, current_player)
        end

        def next_moves_calculator(step)
          MovesCalculator.new(
            step.perform,
            step.to_cell.name,
            current_player,
            prev_beaten_cells: step.beaten_cells
          )
        end

        memoize def should_beat?
          moves_calculator(move_steps.first).any_can_beat?
        end
    end
  end
end
