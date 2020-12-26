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


# [["King Piccolo, First Step to Revival", "Promotion Cards"], ["Surprise Attack Angila", "Promotion Cards"], ["Piccolo Jr., the King's Scion", "Promotion Cards"], ["Launch, Feminine Wiles", "Promotion Cards"], ["Launch, Feminine Wiles", "Promotion Cards"], ["Tapion, Savior From Another Time", "Promotion Cards"], ["Son Goku & Vegeta, Saiyan Synergy", "Promotion Cards"], ["Son Goku & Vegeta, Saiyan Synergy", "Promotion Cards"], ["Veku, the Unpredictable", "Promotion Cards"], ["Anti-Dimensional Slice", "Promotion Cards"], ["Lord Slug, Returned to Life", "Promotion Cards"], ["Frieza, Dark Power Unleashed", "Promotion Cards"], ["Vegeta, the Insurmountable", "Promotion Cards"], ["Master's Aid Whis", "Promotion Cards"], ["Omega Shenron, the Ultimate Shadow Dragon", "Promotion Cards"], ["Omega Shenron, the Ultimate Shadow Dragon", "Promotion Cards"], ["Nuova Shenron, Fair and Square", "Promotion Cards"], ["SS3 Gogeta, Martial Melee", "Promotion Cards"], ["SS3 Gogeta, Martial Melee", "Promotion Cards"], ["Gohanks, Apocalyptic Future", "Promotion Cards"], ["Supreme Kai of Time, Summoned from Another Dimension", "Promotion Cards"], ["Dark Masked King, Deluge of Darkness", "Promotion Cards"]]