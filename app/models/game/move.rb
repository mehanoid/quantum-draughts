# frozen_string_literal: true

module Game
  class Move
    def initialize(board, params)
      @board = board
      @params = params
    end

    def perform!
      from, to = @params
      from_cell = @board.cell_at(from)
      to_cell = @board.cell_at(to)
      from_cell.draught, to_cell.draught = to_cell.draught, from_cell.draught
    end
  end
end
