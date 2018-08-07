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
        [columns.abs, rows.abs].max
      end

      def normalize
        self.class.new(columns: columns / cells_length, rows: rows / cells_length)
      end

      def diagonal?
        columns.abs == rows.abs
      end

      def *(number)
        self.class.new(columns: columns * number, rows: rows * number)
      end

      TOP_RIGHT  = new(columns: 1, rows: 1)
      DOWN_RIGHT = new(columns: 1, rows: -1)
      TOP_LEFT   = new(columns: -1, rows: 1)
      DOWN_LEFT  = new(columns: -1, rows: -1)
      DIAGONALS  = [TOP_RIGHT, DOWN_RIGHT, TOP_LEFT, DOWN_LEFT].freeze
    end
  end
end
