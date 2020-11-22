require 'json'

DeckCard.delete_all
Deck.delete_all
Card.delete_all

Scraper.new.cards

Dir.glob("#{Rails.root}/public/data/**").each do |filename|
  file = File.read(filename)
  data_hash = JSON.parse(file)

  data_hash.each do |data|
    card = Card.new(data)

    if card.number.match(/_/)
      puts "card: #{card.title} #{card.number} not created!"
    else card.save!
      # puts "card: #{card.title} created!"
    end
  end
end

