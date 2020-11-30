namespace :cards do
  task :rating => :environment do
    result_hash = {}

    decks = Deck.where("created_at >= (?)", 30.days.ago).includes([deck_cards: :card])
    decks.each do |deck|
      leader = deck.leader_card

      leader_card_hash ||= result_hash[leader.id] || { count: 0 }
      result_hash[leader.id] =
          {
              card_id: leader.id,
              title: leader.title,
              count: leader_card_hash[:count] + 1
          }

      deck.deck_cards.each do |deck_card|
        deck_card_hash ||= result_hash[deck_card.card_id] || { count: 0 }
        result_hash[deck_card.card_id] =
            {
                card_id: deck_card.card_id,
                title: deck_card.card.title,
                count: deck_card_hash[:count] + 1
            }
      end
    end

    result_hash.each_key do |card_id|
      count = result_hash[card_id][:count]
      rating = (count.to_f / decks.count)
      Card.find(card_id).update_column(:rating, rating)
    end
  end
end