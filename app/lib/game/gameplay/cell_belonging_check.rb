# frozen_string_literal: true

module Game
  module Gameplay
    class CellBelongingCheck
      attr_reader :boards, :cell_name, :current_player

      def initialize(boards, cell_name, current_player)
        @boards = boards
        @cell_name = cell_name
        @current_player = current_player
      end

      def check!
         raise InvalidMove.new, 'player has no draughts on this cell' unless check
      end

      def check
        boards.any?(&method(:cell_belongs_on_board?))
      end

      private

      def cell_belongs_on_board?(board)
        board.cell_at(cell_name).draught&.color == current_player
      end
    end
  end
end
