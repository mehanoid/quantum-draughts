# frozen_string_literal: true

module Game
  class Board
    attr_reader :rows

    def initialize
      @rows = 8.downto(1).map do |row_number|
        ('A'..'H').map.with_index do |column_char, column_index|
          Cell.new(column: column_char,
                   row: row_number,
                   playable: (row_number + column_index).odd?,
                   draught: nil)
        end
      end
    end

    def populate!
      Populator.new(self).populate!
      self
    end

    def cell_at(column, row)
      rows[row - 1][column.ord - 'A'.ord]
    end

    def cells
      rows.flatten
    end

    def as_json(*args)
      cells.reject(&:empty?).map do |cell|
        [cell.name, cell.draught]
      end.to_h
    end
  end
end
