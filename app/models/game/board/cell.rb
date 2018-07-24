# frozen_string_literal: true

module Game
  class Board
    class Cell
      include Dry::Equalizer(:column, :row, :draught)

      attr_reader :column, :row, :playable, :draught

      # @param column [String]
      # @param row [Integer]
      # @param playable [Boolean]
      # @param draught [Game::Draught]
      def initialize(column:, row:, draught: nil)
        @column = column
        @row = row
        @playable = (column_number + row_number).even?
        @draught = draught
      end

      # @return [String] string identifying the cell, e.g. "A4"
      def name
        column + row.to_s
      end

      alias row_number row

      def update(draught: nil)
        self.class.new(column: column, row: row, draught: draught)
      end

      # @return [Boolean]
      def empty?
        !draught
      end

      # @return [Boolean]
      def occupied?
        !empty?
      end

      # Returns array of to integers: columns diff and rows diff
      # @param cell [Game::Board::Cell]
      # @return [Array<Integer>]
      def position_diff(cell)
        [column_number - cell.column_number, row_number - cell.row_number]
      end

      # @param cell [Game::Board::Cell]
      # @return [Boolean]
      def adjacent?(cell)
        position_diff(cell).all? { |d| d.abs <= 1 }
      end

      def same_diagonal?(cell)
        columns_diff, rows_diff = position_diff(cell)
        columns_diff.abs == rows_diff.abs
      end

      # Returns true if cell is lying between other cells on the same diagonal
      # @return [Boolean]
      def between?(cell1, cell2)
        same_diagonal?(cell1) && same_diagonal?(cell2) &&
          self != cell1 && self != cell2 &&
          (column.between?(cell1.column, cell2.column) || column.between?(cell2.column, cell1.column)) &&
          (row.between?(cell1.row, cell2.row) || row.between?(cell2.row, cell1.row))
      end

      # @return [Integer]
      def column_number
        column.ord - 'A'.ord + 1
      end
    end
  end
end
