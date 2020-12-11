namespace :ratings do
  task :update => :environment do
    result_hash = {}

    decks = Deck.where("created_at >= (?)", 30.days.ago)
    decks.each do |deck|

      leader_card_hash ||= result_hash[deck.leader_number] || { count: 0 }
      result_hash[deck.leader_number] =
          {
              number: deck.leader_number,
              count: leader_card_hash[:count] + 1
          }

      deck.main_deck_cards.merge(deck.side_deck_cards).each do |number, value|
        deck_card_hash ||= result_hash[number] || { count: 0 }
        result_hash[number] =
            {
                card_id: number,
                count: deck_card_hash[:count] + 1
            }
      end
    end

    final_result = {}

    result_hash.each_key do |number|
      count = result_hash[number][:count]
      rating = (count.to_f / decks.count)

      final_result[number] = rating.round(4)
    end

    info = Info.first || Info.create
    info.update_column(:ratings, final_result)
  end
end

