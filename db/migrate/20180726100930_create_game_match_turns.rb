# frozen_string_literal: true

class CreateGameMatchTurns < ActiveRecord::Migration[5.2]
  def change
    create_table :game_match_turns do |t|
      t.references :match
      t.integer :turn_number, null: false, default: 1
      t.integer :player, null: false, default: 0
      t.jsonb :last_move
      t.jsonb :boards, null: false

      t.timestamps
    end
  end
end
