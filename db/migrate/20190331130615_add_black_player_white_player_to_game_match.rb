class AddBlackPlayerWhitePlayerToGameMatch < ActiveRecord::Migration[5.2]
  def change
    add_reference :game_matches, :black_player
    add_reference :game_matches, :white_player
  end
end
