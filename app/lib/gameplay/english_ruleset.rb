# frozen_string_literal: true

module Gameplay
  module EnglishRuleset
    class << self
      def build_move_step(board, move_cells, *args, **kwargs)
        from_cell = board.cell_at(move_cells.first)
        klass     =
          if from_cell.draught&.king?
            self::KingMoveStep
          else
            self::ManMoveStep
          end
        klass.new(board, move_cells, *args, **kwargs)
      end

      def max_step_length(_cell)
        2
      end
    end
  end
end
