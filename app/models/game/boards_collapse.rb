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
        draught_ids  = get_draught_ids(boards_cells)
        if too_many_draughts?(draught_ids)
          reject_conflicts_with_draught(boards, draught_ids.sample, cell_name)
        else
          boards
        end
      end

      def get_draught_ids(cells)
        cells.reject(&:empty?).map { |cell| cell.draught.id }
      end

      def too_many_draughts?(draughts)
        draughts.uniq.many?
      end

      # reject all boards that has any draught on that cell that is not our sample draught
      def reject_conflicts_with_draught(boards, draught_id, cell_name)
        boards.reject { |board| cell_conflicts_with?(board.cell_at(cell_name), draught_id) }
      end

      def cell_conflicts_with?(cell, draught_id)
        !cell.empty? && cell.draught.id == draught_id
      end
  end
end
