# frozen_string_literal: true

module Gameplay
  class Board
    class StringExport
      attr_reader :board

      def initialize(board)
        @board = board
      end

      def to_string
        board.rows.reverse.map do |row|
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
            if draught.king?
              '□'
            else
              '○'
            end
          else
            if draught.king?
              '■'
            else
              '●'
            end
          end
        end
    end
  end
end
