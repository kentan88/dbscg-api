class AddColorsToDecks < ActiveRecord::Migration[6.0]
  def change
    add_column :decks, :data, :jsonb, default: {}
    add_column :decks, :colors, :text, array: true, default: []
    add_index :decks, :colors
  end
end