namespace :cards do
  task :series => :environment do
    Card.all.each do |card|
      card.series_text = card.series_text.gsub("～", "~")
      card.save
    end
  end
end