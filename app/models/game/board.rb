# frozen_string_literal: true

module Game
  class Board
    attr_reader :rows

    def initialize(data = {})
      @rows = 1.upto(8).map do |row_number|
        ('A'..'H').map.with_index do |column_char, column_index|
          draught_data = data[column_char + row_number.to_s]
          draught =
            if draught_data
              Draught.new id: draught_data['id'], color: draught_data['c']
            end
          Cell.new(column: column_char,
                   row: row_number,
                   playable: (row_number + column_index).odd?,
                   draught: draught)
        end
      end
    end

    def populate!
      Populator.new(self).populate!
      self
    end

    # @param [String] column column name or cell index
    # @param [Integer, nil] row row number or nil
    # @return [Game::Board::Cell]
    # @example
    #   cell_at('A4')
    #   cell_at('A', 4)
    def cell_at(column, row=nil)
      unless row.present?
        column, row = column.chars
        row = row.to_i
      end
      rows[row - 1][column.ord - 'A'.ord]
    end

    # @return [Array<Game::Board::Cell>]
    def cells
      rows.flatten
    end

    # @return [Array<Game::Board::Draught>]
    def draughts
      cells.map(&:draught).compact
    end

    # Returns an array of cells lying on the same diagonal as the specified two
    # @return [Array<Game::Board::Cell>]
    def diagonal_through_cells(cell1, cell2)
      raise ArgumentError unless cell1.same_diagonal?(cell2)
      cells.select { |c| c.same_diagonal?(cell1) && c.same_diagonal?(cell2) }
    end

    # @return [Array<Game::Board::Cell>]
    def cells_between(cell1, cell2)
      raise ArgumentError unless cell1.same_diagonal?(cell2)
      cells.select { |c| c.between?(cell1, cell2) }
    end

    def as_json(*)
      cells.reject(&:empty?).map do |cell|
        [cell.name, cell.draught]
      end.to_h
    end

    def to_s
      StringExport.new(self).to_string
    end

    class << self
      # @return [Game::Board]
      def from_s(string)
        ::Game::Board::StringImport.new(string).import
      end
    end
  end
end
