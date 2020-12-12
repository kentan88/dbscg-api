class AddColorsToDecks < ActiveRecord::Migration[6.0]
  def change
    add_column :decks, :data, :jsonb, default: {}
    add_column :decks, :colors, :text, array: true, default: []
    add_index :decks, :colors

    decks = Deck.all
    decks.each do |deck|
      colors = deck.main_deck_cards.collect do |number, count|
        card = Card.find_by(number: number)
        card.color.split("/")
      end

      deck.update_column(:colors, colors.flatten.uniq.sort)
    end
  end
end