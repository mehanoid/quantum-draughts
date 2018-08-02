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
        raise(error || InvalidMove) unless valid?
        result
      end

      def perform_while_valid
        raise InvalidMove unless can_partial_perform?
        if valid_steps.last && valid_final_state?(valid_steps.last)
          valid_steps.last.perform
        else
          board
        end
      end

      memoize def valid?
        result.present? && valid_steps.length == move_cells.length - 1
      end

      def can_partial_perform?
        valid_final_state? || valid_steps.length < move_cells.length - 1
      end

      def beat?
        should_beat?
      end

      def valid_final_state?(step = last_step)
        !should_beat? || step && next_moves_calculators(step).none?(&:can_beat?)
      end

      private

        memoize def result
          move_steps.each(&method(:validate_step!))
          validate_final_state!
          last_step&.perform
        rescue InvalidMove => e
          @error = e
          nil
        end

        def validate_final_state!
          raise InvalidMove, 'can not stop if can beat' unless valid_final_state?(last_step)
        end

        def next_moves_calculators(step)
          [next_moves_calculator(step), *alternative_steps(step).map(&method(:next_moves_calculator))]
        end

        # @return [Game::Gameplay::MoveStep]
        def last_step
          move_steps.last
        end

        def alternative_steps(step)
          moves_calculator(step).valid_move_steps.select { |s| same_direction_as_step?(step, s) }
        end

        def same_direction_as_step?(step1, step2)
          step1.from_cell.same_direction?(step1.to_cell, step2.to_cell)
        end

        def valid_steps
          move_steps.take_while(&method(:valid_step?))
        end

        # @return [Array<Game::Gameplay::MoveStep>]
        memoize def move_steps
          move_cells.each_cons(2).with_object([]) do |step_cells, steps|
            step = build_next_step(steps.last, step_cells)
            break steps unless step.valid?
            steps << step
          end
        end

        def build_next_step(prev_step, step_cells)
          MoveStep.build(
            prev_step&.perform || board,
            step_cells,
            current_player,
            prev_beaten_cells: (prev_step&.beaten_cells || [])
          )
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
          MovesCalculator.new(board, move_cells.first, current_player).any_can_beat?
        end
    end
  end
end
