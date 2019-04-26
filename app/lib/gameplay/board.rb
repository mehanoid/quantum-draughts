# frozen_string_literal: true

module Gameplay
  class Board
    include Dry::Equalizer(:cells)

    CELLS_PER_ROW = 8

    attr_reader :cells
    attr_accessor :weight

    class << self
      # @return [Gameplay::Board]
      def from_s(string)
        ::Gameplay::Board::StringImport.new(string).import
      end

      # @param coordinate [String|Gameplay::BoardCellCoordinate] column name or cell index
      # @return [Integer] internal used cell index in cells array
      # @example
      #   cell_index('A4')
      def cell_index(coordinate)
        case coordinate
        when ::Gameplay::BoardCellCoordinate
          column = coordinate.column_number
          row    = coordinate.row_number
        else
          column_name, row_name = coordinate.chars
          column                = column_name.ord - 'A'.ord + 1
          row                   = row_name.to_i
        end
        coordinates_to_index(column, row) if coordinate_valid?(column) && coordinate_valid?(row)
      end

      def populated
        from_s(<<~BOARD)
          . ● . ● . ● . ●
          ● . ● . ● . ● .
          . ● . ● . ● . ●
          . . . . . . . .
          . . . . . . . .
          ○ . ○ . ○ . ○ .
          . ○ . ○ . ○ . ○
          ○ . ○ . ○ . ○ .
        BOARD
      end

      private

        def coordinates_to_index(column_number, row_number)
          CELLS_PER_ROW * (row_number - 1) + (column_number - 1)
        end

        def coordinate_valid?(number)
          number >= 1 && number <= CELLS_PER_ROW
        end
    end

    def initialize(data = {})
      data = data.with_indifferent_access

      @weight = data[:weight] || 1
      cells   = data[:cells] || {}

      @cells = 1.upto(CELLS_PER_ROW).flat_map do |row_number|
        ('A'..'H').map do |column_char|
          draught_data = cells[column_char + row_number.to_s]
          draught      =
            (Draught.new id: draught_data['id'], color: draught_data['c'], king: draught_data['k'] if draught_data)
          BoardCell.new(column:  column_char,
                        row:     row_number,
                        draught: draught)
        end
      end.freeze
    end

    # @param coordinate [String|Gameplay::BoardCellCoordinate] column name or cell index
    # @return [Gameplay::BoardCell]
    # @example
    #   cell_at('A4')
    def cell_at(coordinate)
      index = self.class.cell_index(coordinate)
      cells[index] if index
    end

    def rows
      cells.each_slice(CELLS_PER_ROW).to_a
    end

    def playable_cells
      cells.select(&:playable)
    end

    def occupied_cells
      playable_cells.select(&:occupied?)
    end

    # @return [Array<Gameplay::Board::Draught>]
    def draughts
      cells.map(&:draught).compact
    end

    # @param cell [Gameplay::BoardCell]
    # @param length [Number]
    def diagonals_through_cell(cell, length = nil)
      length         ||= Float::INFINITY
      coordinate     = cell.coordinate
      selected_cells = []
      BoardVector::DIAGONALS.each do |vector|
        (1..length).each do |i|
          selected_cell = cell_at(coordinate + vector * i)
          break unless selected_cell
          selected_cells << selected_cell
        end
      end
      selected_cells
    end

    # @return [Array<Gameplay::BoardCell>]
    def cells_between(cell1, cell2)
      raise ArgumentError unless cell1.same_diagonal?(cell2)
      vector            = cell2.coordinate - cell1.coordinate
      normalized_vector = vector.normalize
      (1...vector.cells_length).map do |factor|
        cell_at(cell1.coordinate + normalized_vector * factor)
      end
    end

    def update(update_params)
      new_board = dup
      new_board.update! update_params
    end

    def as_json(*)
      {
        cells:  cells.reject(&:empty?).map do |cell|
          [cell.name, cell.draught.as_json]
        end.to_h,
        weight: weight,
      }
    end

    def to_s
      StringExport.new(self).to_string
    end

    protected

      def update!(update_params)
        @cells = cells.dup
        update_params.each do |cell_name, draught|
          cells[self.class.cell_index(cell_name)] = cell_at(cell_name).update(draught: draught)
        end
        @cells.freeze
        self
      end
  end
end
