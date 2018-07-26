class RemoveBoardsAndCurrentPlayerFromMatch < ActiveRecord::Migration[5.2]
  def up
    remove_column :game_matches, :current_player
    remove_column :game_matches, :boards
  end

  def down
    add_column :game_matches, :boards, :jsonb
    add_column :game_matches, :turn_number, :integer, default: 1, null: false
  end
end
