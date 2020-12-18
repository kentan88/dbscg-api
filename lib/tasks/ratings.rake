namespace :ratings do
  task :update => :environment do
    leaders_result_hash = {}
    cards_result_hash = {}

    decks = Deck.where("created_at >= (?)", 30.days.ago)
    decks_count = decks.count

    decks.each do |deck|
      leader_card_hash ||= leaders_result_hash[deck.leader_number] || {count: 0}
      leaders_result_hash[deck.leader_number] =
          {
              number: deck.leader_number,
              count: leader_card_hash[:count] + 1
          }

      deck.main_deck_cards.merge(deck.side_deck_cards).each do |number, value|
        deck_card_hash ||= cards_result_hash[number] || {count: 0}
        cards_result_hash[number] =
            {
                card_id: number,
                count: deck_card_hash[:count] + 1
            }
      end
    end


    final_ratings_result = {}

    leader_trending_hash = Hash.new { |hash, key| hash[key] = [] }
    leaders_result_hash.each_key do |number|
      count = leaders_result_hash[number][:count]
      rating = (count.to_f / decks_count).round(4)
      leader_trending_hash[rating] << number

      final_ratings_result[number] = rating
    end

    total_trending_leaders = 0
    final_leaders_trending_results = []
    leader_trending_hash.sort.reverse.each do |rating, card_numbers|
      card_numbers.each do |number|
        if (total_trending_leaders < 10)
          card = Card.find_by(number: number)
          final_leaders_trending_results << {title: card.title, number: card.number, rating: rating}
          total_trending_leaders = total_trending_leaders + 1
        end
      end
    end

    card_trending_hash = Hash.new { |hash, key| hash[key] = [] }
    cards_result_hash.each_key do |number|
      count = cards_result_hash[number][:count]
      rating = (count.to_f / decks_count).round(4)
      card_trending_hash[rating] << number

      final_ratings_result[number] = rating
    end

    total_trending_cards = 0
    final_card_trending_results = []
    card_trending_hash.sort.reverse.each do |rating, card_numbers|
      card_numbers.each do |number|
        if (total_trending_cards < 10)
          card = Card.find_by(number: number)
          final_card_trending_results << {title: card.title, number: card.number, rating: rating}
          total_trending_cards = total_trending_cards + 1
        end
      end
    end

    info = Info.first || Info.create
    info.update_columns({
                            ratings: final_ratings_result,
                            trending: {
                                leaders: final_leaders_trending_results,
                                cards: final_card_trending_results}
                        })
  end
end

