# frozen_string_literal: true

module Game
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

      def resolve_conflicts_on_cell(boards, cell_name)
        boards_cells = boards.map { |b| b.cell_at(cell_name) }
        draughts     = get_draughts(boards_cells)
        if too_many_draughts?(draughts)
          reject_conflicts_with_draught(boards, draughts.sample, cell_name)
        else
          boards
        end
      end

      def get_draughts(cells)
        cells.map(&:draught).compact
      end

      def too_many_draughts?(draughts)
        draughts.uniq.many?
      end

      # reject all boards that has any draught on that cell that is not our sample draught
      def reject_conflicts_with_draught(boards, draught, cell_name)
        boards.reject { |board| cell_conflicts_with?(board.cell_at(cell_name), draught) }
      end

      def cell_conflicts_with?(cell, draught)
        !cell.empty? && cell.draught != draught
      end
  end
end
