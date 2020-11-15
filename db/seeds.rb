require 'json'

Card.delete_all

Dir.glob("#{Rails.root}/public/data/**").each do |filename|

  file = File.read(filename)
  data_hash = JSON.parse(file)

  data_hash.each do |data|
    card = Card.new(data)
    if card.save!
      puts "card: #{card.title} created!"
    end
  end
end

