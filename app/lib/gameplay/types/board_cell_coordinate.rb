# frozen_string_literal: true

module Gameplay
  module Types
    class BoardCellCoordinate
      include Dry::Equalizer(:column_number, :row_number)

      attr_reader :column_number, :row_number

      # @param column [String]
      # @param row [Integer]
      def initialize(column:, row:)
        @row_number    = row
        @column_number =
          if column.is_a? String
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

      # @param other [BoardCellCoordinate]
      def -(other)
        BoardVector.new(
          columns: column_number - other.column_number,
          rows:    row_number - other.row_number
        )
      end

      # @param other [BoardVector]
      def +(other)
        self.class.new(column: column_number + other.columns, row: row_number + other.rows)
      end
    end
  end
end
