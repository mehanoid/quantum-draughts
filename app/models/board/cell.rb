# frozen_string_literal: true

class Board::Cell
  attr_accessor :column, :row, :playable, :draught

  def initialize(column:, row:, playable:, draught:nil)
    self.column = column
    self.row = row
    self.playable = playable
    self.draught = draught
  end
end
