# frozen_string_literal: true

module Game
  class Board
    # converts from string with draughts position to Game::Board
    # @example
    #   StringImport.new(<<~BOARD).import
    #     . ● . ● . ● . ●
    #     ● . ● . ● . ● .
    #     . ● . ● . ● . ●
    #     . . . . . . . .
    #     . . . . . . . .
    #     ○ . ○ . ○ . ○ .
    #     . ○ . ○ . ○ . ○
    #     ○ . ○ . ○ . ○ .
    #   BOARD
    class StringImport
      attr_accessor :board

      # @param string [String]
      def initialize(string)
        @string = string
        @board = Board.new
      end

      # @return [Game::Board]
      def import
        cells_hash = board_cells.zip(cells_chars).map do |cell, char|
          [cell.name, build_draught(char)]
        end.to_h
        board.update(cells_hash)
      end

      private

      def board_cells
        @board.rows.reverse.flatten
      end

      def cells_chars
        @string.remove(/\s/).chars
      end

      def build_draught(char)
        case char
        when '○'
          create_draught(color: :white)
        when '●'
          create_draught(color: :black)
        when '□'
          create_draught(color: :white, king: true)
        when '■'
          create_draught(color: :black, king: true)
        end
      end

      def create_draught(**opts)
        @id ||= 0
        @id += 1
        Draught.new(id: @id, **opts)
      end
    end
  end
end
