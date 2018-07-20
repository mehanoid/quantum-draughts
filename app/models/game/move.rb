# frozen_string_literal: true

module Game
  class Move
    include Memery

    attr_accessor :from_cell, :to_cell, :current_player, :board

    # @param [Game::Board] board
    # @param [Array<String>] move_cells
    def initialize(board, move_cells, current_player = nil)
      @board          = board
      @params         = move_cells
      from, to        = @params
      @from_cell      = @board.cell_at(from)
      @to_cell        = @board.cell_at(to)
      @current_player = current_player
    end

    def perform
      validate!

      move_step.perform
    end

    def valid?
      move_step.valid? && (!should_beat? || move_step.beat?)
    end

    def validate!
      raise InvalidMove, error unless valid?
    end

    private

      memoize def move_step
        MoveStep.build(board, @params, current_player)
      end

      memoize def should_beat?
        PossibleMoves.new(board, @params.first, current_player).should_beat?
      end
  end
end
