# frozen_string_literal: true

module Gameplay
  module Serialization
    class StringExport
      attr_reader :board

      def initialize(board)
        @board = board
      end

      def to_string
        board.rows.reverse.map do |row| # rubocop:disable Style/StringConcatenation
          row_string(row)
        end.join("\n") + "\n"
      end

      private

      def row_string(row)
        row.map do |cell|
          if cell.draught
            draught_char(cell.draught)
          else
            '.'
          end
        end.join(' ')
      end

      def draught_char(draught)
        if draught.white?
          white_draught_char(draught)
        else
          black_draught_char(draught)
        end
      end

      def black_draught_char(draught)
        if draught.king?
          '■'
        else
          '●'
        end
      end

      def white_draught_char(draught)
        if draught.king?
          '□'
        else
          '○'
        end
      end
    end
  end
end
