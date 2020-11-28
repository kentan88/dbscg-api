namespace :leaders do
  task :seed => :environment do
    Card.where(type: "LEADER").each do |card|
      leader = Leader.new
      leader.title = card.title
      leader.title_back = card.title_back
      leader.number = card.number
      leader.save!
    end
  end
end