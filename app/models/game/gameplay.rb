# frozen_string_literal: true

module Game
  class Gameplay
    attr_accessor :boards

    # @param match [Match]
    def initialize(match)
      @match  = match
      @boards = match.board_instances
    end

    def move(quantum_move_params)
      move_groups = quantum_move_params.map do |move_params|
        boards.map do |board|
          Move.new(board, move_params, @match.current_player.to_sym)
        end
      end

      unless move_groups.any?
        # TODO: check for minimum two moves if they are available
        raise InvalidMove, 'too few moves'
      end

      # each move group should contain at least one valid move
      unless move_groups.all? { |moves_group| moves_group.any?(&:valid?) }
        raise InvalidMove, 'one if the moves is invalid'
      end

      new_boards = move_groups.flatten.map do |move|
        if move.valid?
          move.perform
        else
          move.board
        end
      end

      new_boards = BoardsCollapse.new(new_boards).perform
      new_boards = BoardsCompact.new(new_boards).perform

      @match.update! boards: new_boards.map(&:as_json), current_player: next_player
    end

    private

      def next_player
        @match.current_player == 'white' ? 'black' : 'white'
      end
  end
end
