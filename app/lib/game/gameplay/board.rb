# frozen_string_literal: true

module Game
  module Gameplay
    class Board
      include Dry::Equalizer(:cells)

      CELLS_PER_ROW = 8

      attr_reader :cells
      attr_accessor :weight

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

      # @param args [Array] column name or cell index, row number or nil
      # @return [Game::Gameplay::BoardCell]
      # @example
      #   cell_at('A4')
      #   cell_at('A', 4)
      def cell_at(*args)
        index = self.class.cell_index(*args)
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

      # @return [Array<Game::Gameplay::Board::Draught>]
      def draughts
        cells.map(&:draught).compact
      end

      # @param cell [Game::Gameplay::BoardCell]
      # @param length [Number]
      def diagonals_through_cell(cell, length = nil)
        length ||= Float::INFINITY
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

      # @return [Array<Game::Gameplay::BoardCell>]
      def cells_between(cell1, cell2)
        raise ArgumentError unless cell1.same_diagonal?(cell2)
        vector = cell2.coordinate - cell1.coordinate
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

      class << self
        # @return [Game::Gameplay::Board]
        def from_s(string)
          ::Game::Gameplay::Board::StringImport.new(string).import
        end

        # @param column [String] column name or cell index
        # @param row [Integer, nil] row number or nil
        # @return [Integer] internal using cell index in cells array
        # @example
        #   cell_index('A4')
        #   cell_index('A', 4)
        def cell_index(*args)
          case args.first
          when ::Game::Gameplay::BoardCellCoordinate
            column = args.first.column_number
            row    = args.first.row_number
          when String
            column_name, row_name = args.first.chars
            column = column_name.ord - 'A'.ord + 1
            row = row_name.to_i
          else
            column, row = args
          end
          CELLS_PER_ROW * (row - 1) + (column - 1) if column.in?(1..CELLS_PER_ROW) && row.in?(1..CELLS_PER_ROW)
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
end
