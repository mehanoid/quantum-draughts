# frozen_string_literal: true

namespace :sample do
  task boards: :environment do
    Match.last.update boards: [Game::Gameplay::Board.from_s(<<~BOARD)], current_player: :white
      . . . . . . . .
      . . . . ● . . .
      . . . . . . . .
      . . ● . ● . . .
      . . . . . . . .
      . . ● . . . . .
      . ○ . . . ○ . .
      . . . . . . . .
    BOARD
  end
end
