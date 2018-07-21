# frozen_string_literal: true

module Game
  class Move
    include Memery

    attr_accessor :current_player, :board, :move_cells

    # @param [Game::Board] board
    # @param [Array<String>] move_cells
    def initialize(board, move_cells, current_player = nil)
      @board          = board
      @move_cells     = move_cells
      @current_player = current_player
    end

    def perform
      result || raise(@error)
    end

    memoize def valid?
      result.present?
    end

    private

      memoize def result
        result_board = move_cells.each_cons(2).reduce(board, &method(:perform_step))
        validate_final_state!(result_board)
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

      def validate_final_state!(board)
        raise InvalidMove, 'can not stop if can beat' if should_beat? && should_beat?(board)
      end

      memoize def should_beat?(board_ = board)
        PossibleMoves.new(board_, move_cells.first, current_player).should_beat?
      end
  end
end
