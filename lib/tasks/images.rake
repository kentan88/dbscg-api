namespace :images do
  task :seed => :environment do
    # list = ["Activate", "Activate-Battle", "Activate-Main", "Activate_Main-Battle", "Aegis", "Aegis_Blue-Yellow", "Alliance", "Alliance_Red-Green", "Arrival_Blue-Green", "Arrival_Blue-Yellow", "Arrival_Green-Yellow", "Arrival_Red-Blue", "Arrival_Red-Green", "Arrival_Red-Yellow", "Auto", "Awaken", "Awaken_Surge", "Barrier", "Blocker", "Bond_1", "Bond_2", "Bond_3", "Burst-1", "Burst-4", "Burst_2", "Burst_3", "Burst_5", "Counter", "Counter-Attack", "Counter-Battle-Card-Attack", "Counter-Counter", "Counter-Play", "Critical", "Dark-Over-Realm", "Dark-Over-Realm_2", "Dark-Over-Realm_3", "Dark-Over-Realm_4", "Dark-Over-Realm_5", "Dark-Over-Realm_7", "Deflect", "Double-Strike", "Dragon-Ball", "Dual-Attack", "EX-Evolve", "Energy-Exhaust", "Evolve", "Field", "Heroic", "Indestructible", "Invoker", "Offering", "Once-per-turn", "Over-Realm", "Over-Realm-6", "Over-Realm-8", "Over-Realm_10", "Over-Realm_2", "Over-Realm_3", "Over-Realm_4", "Over-Realm_5", "Over-Realm_7", "Overlord", "Permanent", "Quadruple-Strike", "Rejuvenate", "Revenge", "Revive", "Revive_Blue-Green", "Servant", "Sparking_10", "Sparking_15", "Sparking_2", "Sparking_3", "Sparking_5", "Sparking_7", "Successor", "Super-Combo", "Swap", "Swap-6", "Swap_2", "Swap_3", "Swap_4", "Swap_5", "Swap_8", "Triple-Attack", "Triple-Strike", "UNISON_minus_01", "UNISON_minus_02", "UNISON_minus_03", "UNISON_minus_04", "UNISON_minus_05", "UNISON_minus_06", "UNISON_minus_07", "UNISON_plus-minus_00", "UNISON_plus_01", "UNISON_plus_02", "Ultimate", "Union", "Union-Absorb", "Union-Fusion", "Union-Potara", "Unique", "Universe_7", "Victory-Strike", "Villainous", "Wish", "Wormhole", "X", "Xeno-Evolve", "black_ball", "blue_ball", "eight", "five", "four", "green_ball", "one", "red_ball", "seven", "six", "three", "two", "yellow_ball"]
    list = Card.all.collect(&:skills_text).join(" ").scan(/([a-zA-Z0-9_-]+).png/).flatten.uniq.sort
    list << ["Sparking-20", "nine", "sixteen"]

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

    # Card.all.each do |card|
    #   if card.type == "LEADER"
    #     path = Rails.root.join('public', 'images', "#{card.number}.png")
    #     path_2 = Rails.root.join('public', 'images', "#{card.number}_b.png")
    #
    #     if File.file?(path) && File.file?(path_2)
    #       puts "image exist skip"
    #     else
    #       File.open(path, 'wb') do |fo|
    #         puts "downloading"
    #         fo.write open("http://www.dbs-cardgame.com/images/cardlist/cardimg/#{card.number}.png").read
    #       end
    #
    #       File.open(path_2, 'wb') do |fo|
    #         puts "downloading"
    #         fo.write open("http://www.dbs-cardgame.com/images/cardlist/cardimg/#{card.number}_b.png").read
    #       end
    #     end
    #   else
    #     path = Rails.root.join('public', 'images', "#{card.number}.png")
    #
    #     if File.file?(path)
    #       puts "image exist skip"
    #     else
    #       File.open(path, 'wb') do |fo|
    #         puts "downloading"
    #         fo.write open("http://www.dbs-cardgame.com/images/cardlist/cardimg/#{card.number}.png").read
    #       end
    #     end
    #   end
    # end
  end
end