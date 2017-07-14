# frozen_string_literal: true

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
    rows.first(3).flatten.select(&:playable).each {|cell| cell.draught = 'b'}
    rows.last(3).flatten.select(&:playable).each {|cell| cell.draught = 'w'}
    self
  end

  def cell_at(column, row)
    rows[row - 1][column.ord - 'A'.ord]
  end

  def as_json
    rows.flatten.select{|c| c.draught}.map do |cell|
      [cell.column + cell.row.to_s, cell.draught]
    end.to_h
  end
end

