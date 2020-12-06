namespace :cards do
  task :typo => :environment do
    Card.where(series: 'Series6 ~DESTROYER KINGS~').update_all({ series: "Series 6 ~DESTROYER KINGS~"})
    Card.where(series: 'Series7 ~ASSAULT OF THE SAIYANS~').update_all({ series: "Series 7 ~ASSAULT OF THE SAIYANS~"})
  end
end