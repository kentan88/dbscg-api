namespace :decks do
  task :seed => :environment do
    DeckCard.delete_all
    Deck.delete_all

    100.times do |n|
      deck = Deck.create!(name: "My Deck #{n + 1}", card_id: Card.where(type: "LEADER").order("RANDOM()").limit(1).first.id )

      20.times do |m|
        card_id = Card.where.not(type: "LEADER").order("RANDOM()").limit(1).first.id
        deck.deck_cards << DeckCard.create(card_id: card_id, quantity: (2..4).to_a.sample)
      end
    end
  end
end