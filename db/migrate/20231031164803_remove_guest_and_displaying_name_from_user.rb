class RemoveGuestAndDisplayingNameFromUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.remove :guest, type: :boolean, default: false, null: false
      t.remove :displaying_name, type: :string
    end
  end
end
