# frozen_string_literal: true

module Game
  class GamePlay
    attr_accessor :boards

    # @param [Match] match
    def initialize(match)
      @match = match
      @boards = match.boards.map {|board| Board.new(board)}
    end

    def possible_moves(cell_name)
      boards.flat_map do |board|
        board.cells.select do |cell|
          Move.new(board, [cell_name, cell.name], @match.current_player.to_sym).valid?
        end
      end.map(&:name).uniq
    end

    def move(moves)
      new_boards = moves.flat_map do |move|
        boards.map do |board|
          Move.new(board.dup, move, @match.current_player.to_sym).perform!
        end
      end
      @match.update! boards: new_boards.map(&:as_json), current_player: next_player
    end

    private

      def next_player
        @match.current_player == 'white' ? 'black' : 'white'
      end
  end
end
