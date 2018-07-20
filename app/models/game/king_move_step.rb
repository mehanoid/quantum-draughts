# frozen_string_literal: true

module Game
  class KingMoveStep < MoveStep
    def valid_direction?
      true # can move in all directions
    end

    def valid_move_distance?
      true # can move any distance
    end

    # Beaten draughts can not be placed on adjacent cells
    def valid_beaten_cells_order?
      cells_between = board.cells_between(from_cell, to_cell)
      cells_between.each_cons(2).none? { |c1, c2| c1.occupied? && c2.occupied? }
    end
  end
end
