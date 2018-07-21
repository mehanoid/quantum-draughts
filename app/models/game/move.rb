# frozen_string_literal: true

module Game
  # successively performs all MoveStep's, transforming board
  class Move
    include Memery

    attr_reader :current_player, :board, :move_cells, :error

    # @param board [Game::Board] initial board
    # @param move_cells [Array<String>]
    def initialize(board, move_cells, current_player = nil)
      @board          = board
      @move_cells     = move_cells
      @current_player = current_player
    end

    # @return [Game::Board] transformed board
    def perform
      result || raise(error)
    end

    memoize def valid?
      result.present?
    end

    private

      memoize def result
        result_board = move_cells.each_cons(2).reduce(board, &method(:perform_step))
        validate_final_state!(result_board, move_cells.last)
        result_board
      rescue InvalidMove => e
        @error = e
        nil
      end

      def perform_step(board, step_cells)
        step = MoveStep.build(board, step_cells, current_player)
        validate_step!(step)
        step.perform
      end

      def validate_step!(step)
        raise InvalidMove, 'move step should beat' unless !should_beat? || step.beat?
      end

      def validate_final_state!(board, cell)
        raise InvalidMove, 'can not stop if can beat' if should_beat? && PossibleMoves.new(board, cell, current_player).can_beat?
      end

      memoize def should_beat?
        PossibleMoves.new(board, move_cells.first, current_player).any_can_beat?
      end
  end
end
