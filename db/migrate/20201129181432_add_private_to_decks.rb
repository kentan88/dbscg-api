class AddPrivateToDecks < ActiveRecord::Migration[6.0]
  def change
    add_column :decks, :private, :boolean, default: false
    add_index :decks, :private
  end
end
