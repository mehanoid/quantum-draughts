# frozen_string_literal: true

namespace :benchmark do
  task moves: :environment do
    board = Game::Gameplay::Board.from_s(<<~BOARD)
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      ● . . . ○ . . .
      . ● . ○ . . . .
      . . ○ . . . . .
      . ● . ○ . . . .
      ● . . . ○ . . .
    BOARD

    boards = board.occupied_cells
      .map { |cell| { cell.name => cell.draught } }
      .combination(5)
      .map { |bs| Game::Gameplay::Board.new.update(bs.reduce(&:merge)) }

    puts "#{boards.count} boards"
    puts

    iterations = 5

    Benchmark.bm(15) do |x|
      x.report('possible moves') do
        iterations.times do
          Game::Gameplay::QuantumMovesCalculator.valid_possible_move_chains(boards, :white)
        end
      end

      x.report('move') do
        iterations.times do
          Game::Gameplay::QuantumMove.new(boards, [%w[C3 A1], %w[C3 A5]], :white).perform
        end
      end
    end
  end
end
