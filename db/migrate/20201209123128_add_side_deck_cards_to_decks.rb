class AddSideDeckCardsToDecks < ActiveRecord::Migration[6.0]
  def change
    add_column :decks, :side_deck_cards, :jsonb
  end
end
