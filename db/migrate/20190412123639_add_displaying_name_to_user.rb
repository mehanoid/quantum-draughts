# frozen_string_literal: true

class AddDisplayingNameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :displaying_name, :string
  end
end
