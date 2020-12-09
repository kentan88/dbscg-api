class AddUsernameToDecks < ActiveRecord::Migration[6.0]
  def change
    add_column :decks, :username, :string

    decks = Deck.includes(:user, :deck_cards)

    decks.each do |deck|
      main_deck_cards = Hash[deck.deck_cards.where(type: "main").collect { |dc| [dc.number, dc.quantity] }]
      side_deck_cards = Hash[deck.deck_cards.where(type: "side").collect { |dc| [dc.number, dc.quantity] }]

      deck.update_columns({
                              main_deck_cards: main_deck_cards,
                              side_deck_cards: side_deck_cards,
                              username: deck.user.username
                          })
    end
  end
end
