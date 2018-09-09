# frozen_string_literal: true

namespace :sample do
  task boards: :environment do
    boards = [Game::Gameplay::Board.from_s(<<~BOARD)]
      . . . . . . . .
      . . . . ● . . .
      . . . . . . .  .
      . . ● . ● . . .
      ■ . . . . . . .
      . . ● . . . . .
      . ○ . . . ○ . .
      . . . . . □ . .
    BOARD
    Game::Match.last.current_turn.update boards: Game::Gameplay::Board::JsonExport.new(boards).as_json, player: :white
  end
end
