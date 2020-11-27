namespace :decks do
  task :seed => :environment do
    50.times do |n|
      user = User.create(username: Faker::Internet.username, email: Faker::Internet.email, password: 11111111)
      deck = Deck.create!(user_id: user.id, name: "My Super Duper Utimate Deck XXXXXXXXX #{n + 1}", card_id: Card.where(type: "LEADER").order("RANDOM()").limit(1).first.id )

      5.times do |m|
        card_id = Card.where.not(type: "LEADER").order("RANDOM()").limit(1).first.id
        deck.deck_cards << DeckCard.create(card_id: card_id, quantity: (2..4).to_a.sample)
      end
    end
  end
end