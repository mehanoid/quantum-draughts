# frozen_string_literal: true

module Game
  class Gameplay
    include Memery

    attr_reader :boards, :match_turn

    # @param match_turn [Game::MatchTurn]
    def initialize(match_turn)
      @match_turn = match_turn
      @boards     = match_turn.board_instances
    end

    def move(quantum_move_params)
      {
        boards:      Game::Board::JsonExport.new(new_boards(quantum_move_params)).as_json,
        player:      next_player,
        turn_number: next_turn,
        last_move:   last_move(quantum_move_params),
      }
    end

    private

      def new_boards(quantum_move_params)
        build_moves(quantum_move_params)
          .yield_self(&method(:perform_moves))
          .yield_self(&method(:collapse_boards))
          .yield_self(&method(:compact_boards))
      end

      def last_move(quantum_move_params)
        beat = build_moves(quantum_move_params).find(&:valid?).beat?

        quantum_move_params.map do |cells|
          {
            beat: beat,
            cells: cells,
          }
        end
      end

      memoize def build_moves(quantum_move_params)
        move_groups = quantum_move_params.map do |move_params|
          boards.map do |board|
            Move.new(board, move_params, match_turn.player.to_sym)
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
        move_groups.flatten
      end

      def perform_moves(moves)
        moves.map do |move|
          if move.valid?
            move.perform
          else
            move.board
          end
        end
      end

      def collapse_boards(boards)
        BoardsCollapse.new(boards).perform
      end

      def compact_boards(boards)
        BoardsCompact.new(boards).perform
      end

      def next_turn
        match_turn.player == 'white' ? match_turn.turn_number : match_turn.turn_number + 1
      end

      def next_player
        match_turn.player == 'white' ? 'black' : 'white'
      end
  end
end
