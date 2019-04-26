# frozen_string_literal: true

module Gameplay
  class BoardCell
    include Dry::Equalizer(:draught, :coordinate)

    attr_reader :playable, :draught, :coordinate

    delegate :name, :column, :row, :column_number, :row_number, to: :coordinate

    # @param column [String]
    # @param row [Integer]
    # @param coordinate [BoardCellCoordinate]
    # @param draught [Gameplay::Draught]
    def initialize(column: nil, row: nil, coordinate: nil, draught: nil)
      @coordinate = coordinate || BoardCellCoordinate.new(column: column, row: row)
      @playable   = (column_number + row_number).even?
      @draught    = draught
    end

    alias row_number row

    def update(draught: nil)
      self.class.new(coordinate: coordinate, draught: draught)
    end

    # @return [Boolean]
    def empty?
      !draught
    end

    # @return [Boolean]
    def occupied?
      !empty?
    end

    # @param cell [Gameplay::BoardCell]
    # @return [Boolean]
    def adjacent?(cell)
      (coordinate - cell.coordinate).cells_length <= 1
    end

    def same_diagonal?(cell)
      (coordinate - cell.coordinate).diagonal?
    end

    # Returns true if cell is lying between other cells on the same diagonal
    # @return [Boolean]
    def between?(cell1, cell2)
      same_diagonal?(cell1) && same_diagonal?(cell2) &&
        self != cell1 && self != cell2 &&
        (column.between?(cell1.column, cell2.column) || column.between?(cell2.column, cell1.column)) &&
        (row.between?(cell1.row, cell2.row) || row.between?(cell2.row, cell1.row))
    end

    def same_direction?(to_cell1, to_cell2)
      to_cell1.between?(self, to_cell2) || to_cell2.between?(self, to_cell1)
    end

    # @return [Integer]
    def column_number
      column.ord - 'A'.ord + 1
    end
  end
end
