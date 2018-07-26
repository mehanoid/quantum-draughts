# frozen_string_literal: true

module Game
  module Gameplay
    class BoardsCollapse
      def initialize(boards)
        @boards = boards
      end

      def perform
        cell_names.reduce(@boards, &method(:resolve_conflicts_on_cell))
      end

      private

        def cell_names
          @boards.first.cells.map(&:name)
        end

        # @return [Game::Gameplay::Board] boards
        def resolve_conflicts_on_cell(boards, cell_name)
          draughts = get_draughts_at_cell(boards, cell_name)
          if too_many_draughts?(draughts)
            reject_conflicts_with_draught(boards, draughts.sample, cell_name)
          else
            boards
          end
        end

        # multiply single draughts by the probability weight of the board so that we can pick
        # sample draught from the resulting array with correct probability
        # @return [Array<Game::Draught>]
        def get_draughts_at_cell(boards, cell_name)
          boards.flat_map do |b|
            draught = b.cell_at(cell_name).draught
            [draught] * b.weight if draught
          end.compact
        end

        # check if there are different draughts on one cell
        def too_many_draughts?(draughts)
          draughts.uniq.many?
        end

        # reject all boards that has any draught on that cell other than our sample draught
        # @return [Game::Gameplay::Board] boards
        def reject_conflicts_with_draught(boards, draught, cell_name)
          boards.reject { |board| cell_conflicts_with?(board.cell_at(cell_name), draught) }
        end

        def cell_conflicts_with?(cell, draught)
          !cell.empty? && cell.draught != draught
        end
    end
  end
end
