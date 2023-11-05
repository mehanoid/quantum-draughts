# frozen_string_literal: true

# :nocov:
module PerformanceTest
  class Move
    attr_reader :boards

    def initialize
      board = Gameplay::Types::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        ● . . . ○ . . .
        . ● . ○ . . . .
        . . ○ . . . . .
        . ● . ○ . . . .
        ● . . . ○ . . .
      BOARD

      @boards = board.occupied_cells
                     .map { |cell| { cell.name => cell.draught } }
                     .combination(5)
                     .map { |bs| Gameplay::Types::Board.new.update(bs.reduce(&:merge)) }
    end

    def possible_moves
      Gameplay::QuantumBoardMovesCalculator.new(boards, :white).valid_possible_move_chains
    end

    def move
      Gameplay::QuantumMove.new(boards, [%w[C3 A1], %w[C3 A5]], :white).perform
    end
  end
end
# :nocov:
