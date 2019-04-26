# frozen_string_literal: true

module Gameplay
  class CellMeasure
    def initialize(boards, cell_name)
      @boards    = boards
      @cell_name = cell_name
    end

    def perform
      resolve_conflicts_on_cell(@boards, @cell_name)
    end

    private

      # @return [Gameplay::Board] boards
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
          { draught: draught, weight: b.weight }
        end.compact
      end

      # check if there are different draughts on one cell
      def too_many_draughts?(weighted_draughts)
        weighted_draughts.map { |d| d[:draught] }.uniq.many?
      end

      # pick sample draught from the array by it's weight
      # @return [Gameplay::Draught]
      def weighted_draught_sample(weighted_draughts)
        Pickup.new(
          weighted_draughts,
          key_func:    ->(d) { d[:draught] },
          weight_func: ->(d) { d[:weight] },
        ).pick
      end

      # reject all boards that has any draught on that cell other than our sample draught
      # @return [Gameplay::Board] boards
      def reject_conflicts_with_draught(boards, draught, cell_name)
        boards.reject { |board| cell_conflicts_with?(board.cell_at(cell_name), draught) }
      end

      # true if there is any other draught on the specific cell
      def cell_conflicts_with?(cell, draught)
        cell.draught != draught
      end
  end
end
