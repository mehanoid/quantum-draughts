# frozen_string_literal: true

module Game
  class Board::Cell
    attr_accessor :column, :row, :playable, :draught

    def initialize(column:, row:, playable:, draught: nil)
      self.column = column
      self.row = row
      self.playable = playable
      self.draught = draught
    end

    # @return [String] string identifying the cell, e.g. "A4"
    def name
      column + row.to_s
    end

    # @return [Boolean]
    def empty?
      !draught
    end
  end
end
