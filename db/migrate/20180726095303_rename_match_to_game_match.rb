# frozen_string_literal: true

class RenameMatchToGameMatch < ActiveRecord::Migration[5.2]
  def up
    rename_table :matches, :game_matches
  end

  def down
    rename_table :game_matches, :matches
  end
end
