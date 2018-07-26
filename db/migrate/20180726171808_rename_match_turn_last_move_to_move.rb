class RenameMatchTurnLastMoveToMove < ActiveRecord::Migration[5.2]
  def change
    rename_column :game_match_turns, :last_move, :move
  end
end
