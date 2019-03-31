class AddStateToGameMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :game_matches, :state, :integer, null: false, default: 0
  end
end
