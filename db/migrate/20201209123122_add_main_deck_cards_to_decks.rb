class AddMainDeckCardsToDecks < ActiveRecord::Migration[6.0]
  def change
    add_column :decks, :main_deck_cards, :jsonb
  end
end
