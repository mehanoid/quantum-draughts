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

    def move(params)
      Move.new(board, params, @match.current_player.to_sym).perform!
      save!
    end

    private

      def next_player
        @match.current_player == 'white' ? 'black' : 'white'
      end

      def save!
        @match.update! boards: [board].map(&:as_json), current_player: next_player
      end
  end
end
