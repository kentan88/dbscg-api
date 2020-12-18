namespace :images do
  task :seed => :environment do
    # list = Card.all.collect(&:skills_text).join(" ").scan(/([a-zA-Z0-9_-]+).png/).flatten.uniq.sort
    # list << ["Sparking-20", "nine", "sixteen"]

    # list.each do |str|
    #     path = Rails.root.join('public', 'images', 'common', "#{str}.png")
    #   if File.file?(path)
    #     puts "image exist skip"
    #   else
    #     File.open(Rails.root.join('public', 'images', 'common', "#{str}.png"), 'wb') do |fo|
    #       fo.write open("http://www.dbs-cardgame.com/images/cardlist/common/#{str}.png").read
    #     end
    #   end
    # end

    Card.all.each do |card|
      if card.type == "LEADER"
        path = Rails.root.join('public', 'images', "#{card.number}.png")
        path_2 = Rails.root.join('public', 'images', "#{card.number}_b.png")

        if File.file?(path) && File.file?(path_2)
          puts "image exist skip"
        else
          File.open(path, 'wb') do |fo|
            puts "downloading"
            fo.write open("http://www.dbs-cardgame.com/images/cardlist/cardimg/#{card.number}.png").read
          end

          File.open(path_2, 'wb') do |fo|
            puts "downloading"
            fo.write open("http://www.dbs-cardgame.com/images/cardlist/cardimg/#{card.number}_b.png").read
          end
        end
      else
        path = Rails.root.join('public', 'images', "#{card.number}.png")

        if File.file?(path)
          puts "image exist skip"
        else
          File.open(path, 'wb') do |fo|
            puts "downloading"
            fo.write open("http://www.dbs-cardgame.com/images/cardlist/cardimg/#{card.number}.png").read
          end
        end
      end
    end
  end
end