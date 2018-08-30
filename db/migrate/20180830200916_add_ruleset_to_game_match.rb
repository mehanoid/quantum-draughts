class AddRulesetToGameMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :game_matches, :ruleset, :integer, null: false, default: 0
  end
end
