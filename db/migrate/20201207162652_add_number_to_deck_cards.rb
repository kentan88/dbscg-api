class AddNumberToDeckCards < ActiveRecord::Migration[6.0]
  def change
    add_column :deck_cards, :number, :string
    add_index :deck_cards, :number

    DeckCard.all.each do |deck_card|
      card = Card.find(deck_card.card_id)
      deck_card.update_column(:number, card.number)
    end

    change_column_null :deck_cards, :card_id, true
  end
end