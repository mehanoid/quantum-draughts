# frozen_string_literal: true

class AddWinnerToGameMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :game_matches, :finished_at, :datetime
    add_reference :game_matches, :winner
  end
end
