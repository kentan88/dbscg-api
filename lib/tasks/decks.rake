namespace :decks do
  task :seed => :environment do
    # DeckCard.delete_all
    # Deck.delete_all
    # User.delete_all
    # user = User.create(username: "kentan", email: "kentan0130@gmail.com", password: 11111111, password_confirmation: 11111111)

    user = User.first
    leader_card = Card.find_by(title: "Vegeta : Xeno & Trunks : Xeno")

    data = [
        {
            deck_title: "Ultimate Vegeks #1",
            deck_cards: [
                {title: "Haru Haru, Shun Shun's Sister", quantity: 2},
                {title: "Trunks, Elite Descendant", quantity: 4},
                {title: "Power Burst", quantity: 4},
                {title: "Time Agent Vegeta", quantity: 4},
                {title: "Furthering Destruction Champa", quantity: 4},
                {title: "Time Agent Trunks", quantity: 4},
                {title: "SS Gotenks, Fusion of Friendship", quantity: 4},
                {title: "Supreme Kai of Time, Guardian of Spacetime", quantity: 4},
                {title: "SS3 Son Goku, Man on a Mission", quantity: 3},
                {title: "Majin Buu, Wickedness Incarnate", quantity: 3},
                {title: "Black Masked Saiyan, Splintering Mind", quantity: 3},
                {title: "SS Vegeta, the Prince Strikes Back", quantity: 4},
                {title: "Vegeta, Reluctant Reinforcements", quantity: 4},
                {title: "Demon God Demigra, True Power Unleashed", quantity: 4},
            ]
        },
        {
            deck_title: "Budget Vegeks #2",
            deck_cards: [
                {title: "Haru Haru, Shun Shun's Sister", quantity: 4},
                {title: "Trunks, Elite Descendant", quantity: 4},
                {title: "Vegeks, Burning Impact Unleashed", quantity: 4},
                {title: "SS3 Vegeta, Unstoppable Evolution", quantity: 2},
                {title: "Power Burst", quantity: 4},
                {title: "Time Agent Vegeta", quantity: 4},
                {title: "Time Agent Trunks", quantity: 4},
                {title: "Vegeta, Returned from Darkness", quantity: 4},
                {title: "SS Gotenks, Fusion of Friendship", quantity: 4},
                {title: "Supreme Kai of Time, Guardian of Spacetime", quantity: 4},
                {title: "SS3 Son Goku, Man on a Mission", quantity: 4},
                {title: "Vegeks, Spacetime Synthesis", quantity: 4},
                {title: "SS Vegeta, the Prince Strikes Back", quantity: 4},
            ]
        },
        {
            deck_title: "Aggro Vegeks #3",
            deck_cards: [
                {title: "Haru Haru, Shun Shun's Sister", quantity: 4},
                {title: "Trunks, Elite Descendant", quantity: 4},
                {title: "Bibidi, Primeval Conjurer", quantity: 2},
                {title: "Dark Power Black Masked Saiyan", quantity: 3},
                {title: "Power Burst", quantity: 4},
                {title: "Time Agent Vegeta", quantity: 4},
                {title: "Furthering Destruction Champa", quantity: 2},
                {title: "Time Agent Trunks", quantity: 4},
                {title: "SS Gotenks, Fusion of Friendship", quantity: 4},
                {title: "Supreme Kai of Time, Guardian of Spacetime", quantity: 4},
                {title: "SS3 Son Goku, Man on a Mission", quantity: 3},
                {title: "Vegeks, Spacetime Synthesis", quantity: 3},
                {title: "Majin Buu, Wickedness Incarnate", quantity: 4},
                {title: "Black Masked Saiyan, Splintering Mind", quantity: 3},
                {title: "SS Vegeta, the Prince Strikes Back", quantity: 2},
                {title: "Majin Buu's Human Extinction Attack", quantity: 2},
                {title: "Vegeta, Reluctant Reinforcements", quantity: 4},
            ]
        },
        {
            deck_title: "Fun Vegeks #4",
            deck_cards: [
                {title: "Narirama", quantity: 2},
                {title: "Haru Haru, Shun Shun's Sister", quantity: 2},
                {title: "Bibidi, Primeval Conjurer", quantity: 2},
                {title: "Dark Power Black Masked Saiyan", quantity: 3},
                {title: "Temporal Rescue Trunks", quantity: 2},
                {title: "Power Burst", quantity: 4},
                {title: "Time Agent Vegeta", quantity: 4},
                {title: "Time Agent Trunks", quantity: 4},
                {title: "SS Gotenks, Fusion of Friendship", quantity: 4},
                {title: "Hidden Power, East Supreme Kai", quantity: 3},
                {title: "Supreme Kai of Time, Guardian of Spacetime", quantity: 4},
                {title: "SS3 Son Goku, Man on a Mission", quantity: 1},
                {title: "Majin Buu, Wickedness Incarnate", quantity: 3},
                {title: "Four-Star Ball", quantity: 3},
                {title: "Majin Buu's Human Extinction Attack", quantity: 3},
                {title: "Hatchhyack, Hatred Everlasting", quantity: 1},
                {title: "Fu, Mission Accomplished", quantity: 2},
            ]
        },
        {
            deck_title: "Champ Vegeks #5",
            deck_cards: [
                {title: "Haru Haru, Shun Shun's Sister", quantity: 4},
                {title: "Trunks, Elite Descendant", quantity: 4},
                {title: "Power Burst", quantity: 4},
                {title: "Time Agent Vegeta", quantity: 4},
                {title: "Furthering Destruction Champa", quantity: 4},
                {title: "Time Agent Trunks", quantity: 4},
                {title: "SS Gotenks, Fusion of Friendship", quantity: 4},
                {title: "Supreme Kai of Time, Guardian of Spacetime", quantity: 4},
                {title: "SS3 Son Goku, Man on a Mission", quantity: 3},
                {title: "Majin Buu, Wickedness Incarnate", quantity: 3},
                {title: "Black Masked Saiyan, Splintering Mind", quantity: 3},
                {title: "SS Vegeta, the Prince Strikes Back", quantity: 4},
                {title: "SS Vegeks, Mastery Merged", quantity: 1},
                {title: "Majin Buu's Human Extinction Attack", quantity: 3},
                {title: "Vegeta, Reluctant Reinforcements", quantity: 4},
            ]
        }
    ]

    data.each do |deck_item|
      deck = Deck.create!(user_id: user.id, name: deck_item[:deck_title], card_id: leader_card.id)
      deck_item[:deck_cards].each do |card_item|
        card = Card.find_by!(title: card_item[:title])
        deck.deck_cards << DeckCard.create(card_id: card.id, quantity: card_item[:quantity])
      end
    end
  end
end