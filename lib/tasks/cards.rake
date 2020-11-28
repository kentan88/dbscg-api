namespace :cards do
  task :series => :environment do
    Card.all.each do |card|
      card.series_text = card.series_text.gsub("～", "~")
      card.save
    end
  end

  task :power_back => :environment do
    Dir.glob("#{Rails.root}/public/data/**").each do |filename|
      file = File.read(filename)
      data_hash = JSON.parse(file)

      data_hash.each do |data|
        card = Card.find_by(number: data["number"])
        if data["power_back"].length > 0
          puts card.title
          card.power_back = data["power_back"]
          card.save!
        end
      end
    end
  end
end