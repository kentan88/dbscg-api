class AddLeaderNumberToDecks < ActiveRecord::Migration[6.0]
  def change
    change_column_null :decks, :card_id, true
    add_column :decks, :leader_number, :string

    Deck.all.each do |deck|
      deck.leader_number = Card.find(deck.card_id).number
      deck.save
    end
  end
end
