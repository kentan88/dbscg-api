namespace :leaders do
  task :seed => :environment do
    Card.where(type: "LEADER").each do |card|
      leader = Leader.new
      leader.card_id = card.id
      leader.title = card.title
      leader.title_back = card.title_back
      leader.number = card.number
      leader.save!
    end
  end

  task :stats => :environment do
    result_hash = {}

    Deck.includes([deck_cards: :card]).all.each do |deck|
      leader = deck.leader_card
      result_hash[leader.id] ||= {}

      deck.deck_cards.each do |deck_card|
        deck_card_hash ||= result_hash[leader.id][deck_card.card_id] || { "count" => 0 }


        result_hash[leader.id][deck_card.card_id] =
            {
                "card_id" => deck_card.card_id,
                "title" => deck_card.card.title,
                "count" => deck_card_hash["count"] + 1
            }
      end
    end


    result_hash.each_key do |card_id|
      total_num_of_decks = Deck.where(card_id: card_id).count

      leader = Leader.find_by(card_id: card_id)
      leader.stats = {
          deck: {
              total: total_num_of_decks
          },
          results: result_hash[card_id].values.map { |element| element.as_json }.sort_by { |z| z["count"] }.reverse
      }
      leader.save!
    end
  end
end