# frozen_string_literal: true

module Game
  class Board::Populator
    def initialize(board)
      @board = board
      @draughts = []
    end

    def populate!
      playable_cells(rows.first(3)).each {|cell| cell.draught = create_draught(:black)}
      playable_cells(rows.last(3)).each {|cell| cell.draught = create_draught(:white)}
    end

    private

    def create_draught(color)
      draught = Draught.new id: @draughts.count + 1, color: color
      @draughts << draught
      draught
    end

    def rows
      @board.rows
    end

    def playable_cells(rows)
      rows.flatten.select(&:playable)
    end
  end
end
