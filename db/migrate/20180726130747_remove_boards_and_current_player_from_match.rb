# frozen_string_literal: true

class RemoveBoardsAndCurrentPlayerFromMatch < ActiveRecord::Migration[5.2]
  def change
    change_table :game_matches, bulk: true do |t|
      t.remove :current_player, type: :integer, default: 1, null: false
      t.remove :boards, type: :jsonb
    end
  end
end
