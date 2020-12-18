Dir.glob("#{Rails.root}/public/data/**").sort.each do |filename|
  file = File.read(filename)
  data_hash = JSON.parse(file)

  data_hash.each do |data|
    card = Card.new(data)
    card.title = card.title.strip
    card.skills_text = nil if card.skills_text == "-"
    if card.save
      puts "#{card.number} created"
    else
      puts "#{card.number} exists. Not saving"
    end
  end
end

# Card.where(series: 'Series6 ~DESTROYER KINGS~').update_all({ series: "Series 6 ~DESTROYER KINGS~"})
# Card.where(series: 'Series7 ~ASSAULT OF THE SAIYANS~').update_all({ series: "Series 7 ~ASSAULT OF THE SAIYANS~"})
# Card.where("special_trait ilike (?)", "%Universe7").each do |card|
#   card.special_trait = card.special_trait.gsub("Universe7", "Universe 7")
#   card.save
# end
