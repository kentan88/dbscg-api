namespace :cards do
  task :series => :environment do
    Card.all.each do |card|
      card.series_text = card.series.join(" ")
      card.save
    end
  end
end