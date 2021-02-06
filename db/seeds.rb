cards_added = []

Dir.glob("#{Rails.root}/public/data/**").sort.each do |filename|
  file = File.read(filename)
  data_hash = JSON.parse(file)

  data_hash.each do |data|
    card = Card.new(data)
    card.title = card.title.strip
    card.skills_text = nil if card.skills_text == "-"
    if card.save
      cards_added << card.number
      puts "#{card.number} created"
    end
  end
end

puts cards_added.join(" ")

# Card.where(series: "Series 4  ~COLOSSAL WARFARE~").update_all({ series: "Series 4 ~COLOSSAL WARFARE~"})
# Card.where(series: "Series 5  ~MIRACULOUS REVIVAL~").update_all({ series: "Series 5 ~MIRACULOUS REVIVAL~"})
# Card.where(series: 'Series6 ~DESTROYER KINGS~').update_all({ series: "Series 6 ~DESTROYER KINGS~"})
# Card.where(series: 'Series7 ~ASSAULT OF THE SAIYANS~').update_all({ series: "Series 7 ~ASSAULT OF THE SAIYANS~"})
# Card.where(series: "Unison Warrior Series VICIOUS REJUVENATION").update_all({ series: "Unison Warrior Series Vicious Rejuvenation"})
# Card.where("special_trait ilike (?)", "%Universe7").each do |card|
#   card.special_trait = card.special_trait.gsub("Universe7", "Universe 7")
#   card.save
# end