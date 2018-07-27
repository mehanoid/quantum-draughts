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
          weighted_draughts = get_weighted_draughts_at_cell(boards, cell_name)
          if too_many_draughts?(weighted_draughts)
            reject_conflicts_with_draught(boards, weighted_draught_sample(weighted_draughts), cell_name)
          else
            boards
          end
        end

        # hash of all draughts at cell with weight of board
        # @return [Array<Hash>]
        def get_weighted_draughts_at_cell(boards, cell_name)
          boards.flat_map do |b|
            draught = b.cell_at(cell_name).draught
            { draught: draught, weight: b.weight } if draught
          end.compact
        end

        # check if there are different draughts on one cell
        def too_many_draughts?(weighted_draughts)
          weighted_draughts.map { |d| d[:draught] }.uniq.many?
        end

        # pick sample draught from the array by it's weight
        # @return [Game::Gameplay::Draught]
        def weighted_draught_sample(weighted_draughts)
          Pickup.new(
            weighted_draughts,
            key_func:    ->(d) { d[:draught] },
            weight_func: ->(d) { d[:weight] },
          ).pick
        end

        # reject all boards that has any draught on that cell other than our sample draught
        # @return [Game::Gameplay::Board] boards
        def reject_conflicts_with_draught(boards, draught, cell_name)
          boards.reject { |board| cell_conflicts_with?(board.cell_at(cell_name), draught) }
        end

        # true if there is any other draught on the specific cell
        def cell_conflicts_with?(cell, draught)
          !cell.empty? && cell.draught != draught
        end
    end
  end
end
