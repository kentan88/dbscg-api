require 'json'

DeckCard.delete_all
Deck.delete_all
Card.delete_all

Dir.glob("#{Rails.root}/public/data/**").each do |filename|
  file = File.read(filename)
  data_hash = JSON.parse(file)

  data_hash.each do |data|
    card = Card.new(data)
    card.save!
  end
end

