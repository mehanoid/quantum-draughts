# frozen_string_literal: true

module Gameplay
  module EnglishRuleset
    class KingMoveStep < MoveStep

      private

        def valid_direction?
          true # can move in all directions
        end

        def valid_move_distance?
          from_cell.adjacent?(to_cell)
        end

        def valid_beaten_cells_order?
          cells_between = board.cells_between(from_cell, to_cell)
          cells_between.one? && cells_between.first.occupied?
        end
    end
  end
end
