# frozen_string_literal: true

module Game
  class GamePlay
    attr_accessor :board

    # @param [Match] match
    def initialize(match)
      @match = match
      @board = Board.new(match.boards.first)
    end

    def possible_moves(cell_name)
      board.cells.select do |cell|
        Move.new(board, [cell_name, cell.name], @match.current_player.to_sym).valid?
      end
    end

    def move(moves)
      boards = moves.map do |move|
        Move.new(board.dup, move, @match.current_player.to_sym).perform!
      end
      @match.update! boards: boards.map(&:as_json), current_player: next_player
    end

    private

      def next_player
        @match.current_player == 'white' ? 'black' : 'white'
      end
  end
end
