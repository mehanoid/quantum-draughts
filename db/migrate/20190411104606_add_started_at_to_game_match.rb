# frozen_string_literal: true

class AddStartedAtToGameMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :game_matches, :started_at, :datetime
  end
end
