namespace :redis do
  # task :seed => :environment do
  #   Card.all.each do |card|
  #     REDIS.hset("card_info:#{card.number}", card.attributes.reject { |attr| ["skills", "skills_back"].include?(attr) }.to_a.flatten)
  #   end
  # end

  task :seed_game => :environment do
    Dir.glob("#{Rails.root}/spec/fixtures/**").sort.each do |filename|
      file = File.read(filename)
      data_hash = JSON.parse(file)

      data_hash.each do |data|
        REDIS.hset("card_info:#{data["number"]}", data.to_h.to_a.flatten)
      end
    end
  end
end