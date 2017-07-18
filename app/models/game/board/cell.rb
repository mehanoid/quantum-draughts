# frozen_string_literal: true

module Game
  class Board::Cell
    attr_accessor :column, :row, :playable, :draught

    # @param [String] column
    # @param [Integer] row
    # @param [Boolean] playable
    # @param [Game::Draught] draught
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

    # @param [Game::Board::Cell] cell
    # @return [Array<Integer>]
    def position_diff(cell)
      [column_number - cell.column_number, row_number - cell.row_number]
    end

    def ajacent?(cell)
      position_diff(cell).all? {|d| d.abs <= 1}
    end

    # @return [Integer]
    def column_number
      column.ord - 'A'.ord + 1
    end

    alias row_number row
  end
end
