# frozen_string_literal: true

class CreateGamePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :game_players do |t|
      t.uuid :uuid, index: { unique: true }
      t.belongs_to :user, foreign_key: true, index: { unique: true }
      t.string :displaying_name

      t.timestamps
    end
  end
end
