# frozen_string_literal: true

module Game
  module Gameplay
    class BoardCellCoordinate
      include Dry::Equalizer(:column_number, :row_number)

      attr_reader :column_number, :row_number

      # @param column [String]
      # @param row [Integer]
      def initialize(column:, row:)
        @row_number    = row
        @column_number = if column.is_a? String
          column.ord - 'A'.ord + 1
        else
          column
        end
      end

      # @return [String] string identifying the cell, e.g. "A4"
      def name
        column + row.to_s
      end

      def column
        (column_number + 'A'.ord - 1).chr
      end

      alias row row_number

      def -(coordinate)
        BoardVector.new(
          columns: column_number - coordinate.column_number,
          rows:    row_number - coordinate.row_number
        )
      end

      def +(vector)
        self.class.new(column: column_number + vector.columns, row: row_number + vector.rows)
      end
    end
  end
end
