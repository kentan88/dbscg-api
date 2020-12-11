namespace :images do
  task :seed => :environment do
    # [
    #     "Alliance", "Dark-Over-Realm_5", "Rejuvenate", "Sparking-20", "Wormhole", "sixteen",
    #     "red_ball", "blue_ball", "black_ball", "yellow_ball", "green_ball",
    #     "EX-Evolve", "Deflect", "Counter-Play", "Triple-Strike", "Auto",
    #     "Permanent", "Counter", "Awaken", "Activate-Main", "Activate-Battle",
    #     "Barrier", "Critical", "Super-Combo", "Counter-Play", "Blocker",
    #     "Swap_2", "Swap_3", "Swap_4", "Swap_5", "Dark-Over-Realm", "Over-Realm",
    #     "Over-Realm_4", "Over-Realm_3", "Over-Realm_2", "Over-Realm_5", "Dual-Attack",
    #     "Energy-Exhaust", "Once-per-turn", "Arrival_Red-Green", "Awaken_Surge",
    #     "Counter-Counter", "Counter-Attack", "Arrival_Red-Yellow", "Offering",
    #     "Victory-Strike",
    #     "UNISON_plus-minus_00",
    #     "UNISON_plus_01",
    #     "UNISON_plus_02",
    #     "UNISON_minus_01",
    #     "UNISON_minus_02",
    #     "UNISON_minus_03",
    #     "UNISON_minus_04",
    #     "UNISON_minus_05",
    #     "UNISON_minus_06",
    #     "UNISON_minus_07",
    #     "Burst_2",
    #     "Burst_3",
    #     "Burst-4",
    #     "Burst_5",
    #     "Revenge",
    #     "Triple-Attack",
    #     "Double-Strike",
    #     "Quadruple-Strike",
    #     "one",
    #     "two",
    #     "Activate_Main-Battle",
    #     "Sparking_3",
    #     "Sparking_5",
    #     "Sparking_7",
    #     "Alliance_Red-Green",
    #     "Aegis_Blue-Yellow",
    #     "Revive_Blue-Green",
    #     "Invoker",
    #     "Union",
    #     "Successor",
    #     "Swap",
    #     "Swap_2",
    #     "Swap_3",
    #     "Swap_4",
    #     "Swap_5",
    #     "Swap_6",
    #     "Swap_8",
    #     "Union-Fusion",
    #     "Servant",
    #     "Unique",
    #     "Overlord",
    #     "Activate_Main-Battle",
    #     "Field",
    #     "Over-Realm-6",
    #     "Ultimate",
    #     "Wish",
    #     "Union-Potara",
    #     "Indestructible",
    #     "Aegis",
    #     "Arrival_Blue-Yellow",
    #     "Evolve",
    #     "Sparking_10",
    #     "Union-Absorb",
    #     "Sparking_15",
    #     "Villainous",
    #     "Heroic",
    #     "Bond_2",
    #     "Bond_3",
    #     "three",
    #     "Dragon-Ball",
    #     "Counter-Battle-Card-Attack",
    #     "four",
    #     "five",
    #     "six", "seven", "eight", "nine",
    #     "Bond_1",
    #     "Universe_7",
    #     "Arrival_Green-Yellow",
    #     "Xeno-Evolve",
    #     "Over-Realm-8",
    #     "Over-Realm-7",
    #     "Arrival_Blue-Green",
    #     "Arrival_Red-Blue",
    #     "Revive"
    # ].each do |str|
    #     path = Rails.root.join('public', 'images', "#{str}.png")
    #   if File.file?(path)
    #     puts "image exist skip"
    #   else
    #     File.open(Rails.root.join('public', 'images', "#{str}.png"), 'wb') do |fo|
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