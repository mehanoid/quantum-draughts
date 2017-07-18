# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.jsonb :boards

      t.timestamps
    end
  end
end
