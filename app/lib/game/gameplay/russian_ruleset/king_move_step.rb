# frozen_string_literal: true

module Game
  module Gameplay
    module RussianRuleset
      class KingMoveStep < MoveStep

        private

          def valid_direction?
            true # can move in all directions
          end

          def valid_move_distance?
            true # can move any distance
          end

          # Beaten draughts can not be placed on adjacent cells
          def valid_beaten_cells_order?
            cells_between = board.cells_between(from_cell, to_cell)
            cells_between.one?(&:occupied?)
          end
      end
    end
  end
end
