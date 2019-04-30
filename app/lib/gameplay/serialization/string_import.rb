# frozen_string_literal: true

module Gameplay
  module Serialization
    # converts from string with draughts position to Gameplay::Types::Board
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
      attr_reader :board

      # @param string [String]
      def initialize(string)
        @string = string
        @board  = Types::Board.new
      end

      # @return [Gameplay::Types::Board]
      def import
        cells_hash = board_cells.zip(cells_chars).map do |cell, char|
          [cell.name, build_draught(char)]
        end.to_h
        board.update(cells_hash)
      end

      private

        def board_cells
          @board.rows.flatten
        end

        def cells_chars
          @string.lines.reverse.join.remove(/\s/).chars
        end

        def build_draught(char)
          case char
          when '○'
            create_white_draught
          when '●'
            create_black_draught
          when '□'
            create_white_draught king: true
          when '■'
            create_black_draught king: true
          end
        end

        def create_white_draught(**opts)
          @white_id ||= 0
          @white_id += 1
          Types::Draught.new(id: @white_id, color: :white, **opts)
        end

        def create_black_draught(**opts)
          @black_id ||= 12
          @black_id += 1
          Types::Draught.new(id: @black_id, color: :black, **opts)
        end
    end
  end
end
