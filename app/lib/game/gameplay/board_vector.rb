# frozen_string_literal: true

module Game
  module Gameplay
    class BoardVector
      include Dry::Equalizer(:columns, :rows)

      attr_reader :columns, :rows

      # @param columns [Integer]
      # @param rows [Integer]
      def initialize(columns:, rows:)
        @columns = columns
        @rows    = rows
      end

      def cells_length
        columns.abs
      end

      def normalize
        self.class.new(columns: columns / cells_length, rows: rows / cells_length)
      end

      def *(number)
        self.class.new(columns: columns * number, rows: rows * number)
      end
    end
  end
end
