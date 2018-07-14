# frozen_string_literal: true

module Game
  class GamePlay
    attr_accessor :boards

    # @param [Match] match
    def initialize(match)
      @match  = match
      @boards = match.boards.map { |board| Board.new(board) }
    end

    def possible_moves(cell_name)
      boards.flat_map do |board|
        board.cells.select do |cell|
          Move.new(board, [cell_name, cell.name], @match.current_player.to_sym).valid?
        end
      end.map(&:name).uniq
    end

    def move(moves_params)
      move_groups = moves_params.map do |move_params|
        boards.map do |board|
          Move.new(board.dup, move_params, @match.current_player.to_sym)
        end
      end

      # each move group should contain at least one valid move
      raise InvalidMove unless move_groups.all? { |moves_group| moves_group.any?(&:valid?) }

      new_boards = move_groups.flatten.map do |move|
        if move.valid?
          move.perform!
        else
          move.board
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
