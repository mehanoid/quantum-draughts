# frozen_string_literal: true

namespace :sample do
  task boards: :environment do
    Match.last.update boards: [Game::Board.from_s(<<~BOARD)], current_player: :white
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . ● . ● . . .
      . . . . . . . .
      . . ● . . . . .
      . ○ . . . . ○ .
      . . . . . . . .
    BOARD
  end
end
