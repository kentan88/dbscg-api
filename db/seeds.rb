# require 'json'

# DeckCard.delete_all
# Deck.delete_all
# Card.delete_all
#
# User.create(username: "kentan", email: "kentan0130@gmail.com", password: 11111111, password_confirmation: 11111111)

# Dir.glob("#{Rails.root}/public/data/**").sort.each do |filename|
#   file = File.read(filename)
#   data_hash = JSON.parse(file)
#
#   data_hash.each do |data|
#     card = Card.new(data)
#     card.title = card.title.strip
#     card.skills_text = nil if card.skills_text == "-"
#     card.save!
#   end
# end
