# frozen_string_literal: true

class AddCurrentPlayerToMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :current_player, :integer, null: false, default: 0
  end
end
