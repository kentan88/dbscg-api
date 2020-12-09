class AddDraftToDecks < ActiveRecord::Migration[6.0]
  def change
    add_column :decks, :draft, :boolean, default: false
    add_index :decks, :draft
  end
end
