# frozen_string_literal: true

module Game
  module Gameplay
    class QuantumMove
      attr_reader :boards, :moves_params, :current_player

      # @param boards [Array<Game::GamePlay::Board>]
      def initialize(boards, moves_params, current_player)
        @boards         = boards
        @moves_params   = moves_params
        @current_player = current_player
      end

      def perform
        validate_moves_params!
        build_moves(moves_params)
          .yield_self(&method(:perform_moves))
          .yield_self(&method(:collapse_boards))
          .yield_self(&method(:compact_boards))
      end

      def beat?
        build_moves(moves_params).any? { |m| m.valid? && m.beat? }
      end

      private

        def validate_moves_params!
          raise InvalidMove, 'moves should start with one cell' if moves_params.map(&:first).uniq.many?
        end

        def build_moves(moves_params)
          move_groups = moves_params.map do |move_params|
            boards.map do |board|
              Move.new(board, move_params, current_player)
            end
          end

          validate_move_groups!(move_groups)
          move_groups.flatten
        end

        def validate_move_groups!(move_groups)
          unless move_groups.any?
            # TODO: check for minimum two moves if they are available
            raise InvalidMove, 'too few moves'
          end

          # each move group should contain at least one valid move
          unless move_groups.all? { |moves_group| moves_group.any?(&:valid?) }
            raise InvalidMove, 'one if the moves is invalid'
          end

          unless move_groups.flatten.all?(&:can_partial_perform?)
            raise InvalidMove, 'can not stop if can beat'
          end
        end

        def perform_moves(moves)
          moves.map do |move|
            if move.valid?
              move.perform
            else
              move.perform_while_valid
            end
          end
        end

        def collapse_boards(boards)
          BoardsCollapse.new(boards).perform
        end

        def compact_boards(boards)
          BoardsCompact.new(boards).perform
        end
    end
  end
end
