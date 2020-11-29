namespace :decks do
  task :seed => :environment do
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
        card = Card.find_by!(title: card_item[:title].strip)
        deck.deck_cards << DeckCard.create(card_id: card.id, quantity: card_item[:quantity])
      end
    end

    leader_card = Card.where(title: "Gotenks", type: "LEADER").last

    data = [
        {
            deck_title: "Mighty Gotenks #1",
            deck_cards: [
                {title: "Trunks, Bonds of Friendship", quantity: 2},
                {title: "Buu Buu Volleyball", quantity: 1},
                {title: "Son Gohan, Potential Unlocked", quantity: 2},
                {title: "Son Goten & Trunks, Faultless Youth", quantity: 4},
                {title: "Gokule, the Legendary Fusion Warrior", quantity: 4},
                {title: "Gotenks, the Grim Reaper of Justice", quantity: 4},
                {title: "Shocking Death Ball", quantity: 1},
                {title: "Android 18, Bionic Blitz", quantity: 4},
                {title: "SS3 Vegito, Peerless Warrior", quantity: 4},
                {title: "Max Power Kamehameha", quantity: 1},
                {title: "Son Goten, Brimming With Talent", quantity: 1},
                {title: "Master Roshi, Kamehameha Origins", quantity: 2},
                {title: "Golden Frieza, Unison of Malice", quantity: 2},
                {title: "SS3 Gotenks, All-Out Assault", quantity: 1},
                {title: "Trunks, Brimming With Talent", quantity: 1},
                {title: "Frieza, Charismatic Villain", quantity: 4},
                {title: "Zarbon, Cosmic Elite", quantity: 2},
                {title: "Dormant Potential Unleashed", quantity: 4},
                {title: "Ribrianne, Punishing Passion	", quantity: 3},
                {title: "Great Ape Masked Saiyan, Primal Carnage", quantity: 1},
                {title: "Fused Zamasu, Deity's Wrath", quantity: 2},
            ]
        },
        {
            deck_title: "Budget Gotenks #2",
            deck_cards: [
                {title: "Sorrowful Strike Tien Shinhan", quantity: 2},
                {title: "Videl, a Hero's Daughter", quantity: 2},
                {title: "Trunks, Bonds of Friendship", quantity: 4},
                {title: "Buu Buu Volleyball", quantity: 4},
                {title: " Son Goten, Bonds of Friendship	", quantity: 4},
                {title: " Son Gohan, Potential Unlocked	", quantity: 3},
                {title: " Son Goten & Trunks, Faultless Youth	", quantity: 4},
                {title: " Gokule, the Legendary Fusion Warrior	", quantity: 4},
                {title: " Gotenks, the Grim Reaper of Justice	", quantity: 4},
                {title: " Shocking Death Ball	", quantity: 4},
                {title: " SS3 Vegito, Peerless Warrior	", quantity:4},
                {title: " Great Saiyaman, Vanquisher of Villainy	", quantity: 4},
                {title: " Unified Spirit Son Goten	", quantity: 1},
                {title: " SS3 Son Goku, Man on a Mission	", quantity: 1},
                {title: " SS3 Gotenks, All-Out Assault	", quantity: 1},
                {title: " Frieza, Charismatic Villain	", quantity: 4},
            ]
        },
        {
            deck_title: "Discard Gotenks #3",
            deck_cards: [
                {title: " Trunks, Bonds of Friendship	", quantity: 4},
                {title: " Son Goten, Bonds of Friendship	", quantity: 1},
                {title: " Son Gohan, Potential Unlocked	", quantity: 2},
                {title: " Son Goten & Trunks, Faultless Youth	", quantity: 4},
                {title: " Gokule, the Legendary Fusion Warrior	", quantity: 4},
                {title: " Gotenks, the Grim Reaper of Justice	", quantity: 4},
                {title: " Shocking Death Ball	", quantity: 3},
                {title: " Android 18, Bionic Blitz	", quantity: 2},
                {title: " SS3 Vegito, Peerless Warrior	", quantity: 4},
                {title: " Master Roshi, Kamehameha Origins	", quantity: 2},
                {title: " Dark Broly, Overwhelming Evil	", quantity: 2},
                {title: " SS3 Gotenks, All-Out Assault	", quantity: 2},
                {title: " Defending Father Paragus	", quantity: 2},
                {title: " Frieza, Charismatic Villain	", quantity: 4},
                {title: " Cell's Earth-Destroying Kamehameha	", quantity: 3},
                {title: " Zarbon, Cosmic Elite	", quantity: 2},
                {title: " Dormant Potential Unleashed	", quantity: 4},
                {title: " Fused Zamasu, Deity's Wrath	", quantity: 2},
                {title: " Cell Xeno, Unspeakable Abomination	", quantity: 1},
            ]
        }
    ]

    data.each do |deck_item|
      deck = Deck.create!(user_id: user.id, name: deck_item[:deck_title], card_id: leader_card.id)
      deck_item[:deck_cards].each do |card_item|
        card = Card.find_by!(title: card_item[:title].strip)
        deck.deck_cards << DeckCard.create(card_id: card.id, quantity: card_item[:quantity])
      end
    end
  end
end