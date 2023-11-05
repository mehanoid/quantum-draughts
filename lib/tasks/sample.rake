# frozen_string_literal: true

# :nocov:
namespace :sample do
  task boards: :environment do
    boards = [Gameplay::Board.from_s(<<~BOARD)]
      . . . . . . . .
      . . . . . . . .
      . ● . . . . . .
      . . ● . . . . .
      . . . . . . . .
      . . ● . . . . .
      . ○ . . . ○ . .
      . . . . . . . .
    BOARD
    Game::Match.last.current_turn.update!(
      boards: Gameplay::Board::JsonExport.new(boards).as_json,
      player: :white,
    )
    Game::Match.last.update!(
      white_player: User.first,
      black_player: User.last,
      state:        :started,
      winner_id:    nil,
    )
  end
end
# :nocov:
