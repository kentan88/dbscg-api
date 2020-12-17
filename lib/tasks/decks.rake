namespace :decks do
  task :update_colors => :environment do
    decks = Deck.where(colors: [])

    decks.each do |deck|
      mono_colors = deck.main_deck_cards.collect do |number, count|
        card = Card.find_by(number: number)
        card.color.split("/")
      end

      colors_hash = {colors: {}}
      deck.main_deck_cards.each do |number, count|
        card = Card.find_by(number: number)
        colors_hash[:colors][card.color] = (colors_hash[:colors][card.color] || 0) + count
      end

      deck.update_columns({
                              colors: mono_colors.flatten.uniq.sort,
                              data: colors_hash
                          })
    end
  end
end