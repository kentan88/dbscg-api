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

["BT12-056",
"BT12-057",
"BT12-058",
"BT12-059",
"BT12-060",
"BT12-061",
"BT12-062",
"BT12-063",
"BT12-064",
"BT12-065",
"BT12-066",
"BT12-067",
"BT12-068",
"BT12-069",
"BT12-070",
"BT12-071",
"BT12-072",
"BT12-073",
"BT12-074",
"BT12-075",
"BT12-076",
"BT12-077",
"BT12-078",
"BT12-079",
"BT12-080",
"BT12-081",
"BT12-082",
"BT12-083",
"BT12-084"].each do |number|
  card = Card.find_by(number: number)
  card.update_column(:limit, 4)
end