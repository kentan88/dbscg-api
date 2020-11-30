namespace :cards do
  task :rating => :environment do
    result_hash = {}

    decks = Deck.where("created_at >= (?)", 30.days.ago).includes([deck_cards: :card])
    decks.each do |deck|
      leader = deck.leader_card

      deck.deck_cards.each do |deck_card|
        deck_card_hash ||= result_hash[deck_card.card_id] || { "count" => 0 }


        result_hash[deck_card.card_id] =
            {
                "card_id" => deck_card.card_id,
                "title" => deck_card.card.title,
                "count" => deck_card_hash["count"] + 1
            }
      end
    end

    result_hash.each_key do |card_id|
      count = result_hash[card_id]["count"]
      rating = (count.to_f / decks.count)
      Card.find(card_id).update_column(:rating, rating)
    end
  end


    #   total_num_of_decks = Deck.where(card_id: card_id).count
    #
    #   leader = Leader.find_by(card_id: card_id)
    #   leader.stats = {
    #       deck: {
    #           total: total_num_of_decks
    #       },
    #       results: result_hash[card_id].values.map { |element| element.as_json }.sort_by { |z| z["count"] }.reverse
    #   }
    #   leader.save!
    # end
  # end
end