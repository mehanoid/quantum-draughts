# frozen_string_literal: true

module Game
  class DraughtMoveStep < MoveStep
    def attributes_for_update
      if becomes_king?
        super.merge to_cell.name => draught.becomes_king
      else
        super
      end
    end

    def valid_direction?
      return true if beat?
      if draught.white?
        to_cell.row_number > from_cell.row_number
      else
        to_cell.row_number < from_cell.row_number
      end
    end

    # Beaten cells should be placed alternating with the free ones,
    # so that the draught can jump over them
    def valid_beaten_cells_order?
      cells_between = @board.cells_between(from_cell, to_cell)
      return false unless cells_between.first.occupied? && cells_between.last.occupied?
      cells_between.each_with_index.all? do |cell, index|
        (index.even? && cell.occupied?) || (index.odd? && cell.empty?)
      end
    end

    def valid_move_distance?
      from_cell.adjacent?(to_cell)
    end

    def becomes_king?
      draught.white? && to_cell.row_number == 8 ||
        draught.black? && to_cell.row_number == 1
    end
  end
end
