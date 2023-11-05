# frozen_string_literal: true

class RenameGameMatchTurnPlayerToPlayerColor < ActiveRecord::Migration[7.0]
  def change
    rename_column :game_match_turns, :player, :player_color
  end
end
