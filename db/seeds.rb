Dir.glob("#{Rails.root}/public/data/**").sort.each do |filename|
  file = File.read(filename)
  data_hash = JSON.parse(file)
  cards_added =[]

  data_hash.each do |data|
    card = Card.new(data)
    card.title = card.title.strip
    card.skills_text = nil if card.skills_text == "-"
    if card.save
      cards_added << card.number
      puts "#{card.number} created"
    end
  end

  puts cards_added.join(" ")
end