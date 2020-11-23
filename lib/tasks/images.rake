namespace :images do
  task :seed => :environment do
    [
        "red_ball", "blue_ball", "black_ball", "yellow_ball", "green_ball",
        "EX-Evolve", "Deflect", "Counter-Play", "Triple-Strike", "Auto",
        "Permanent", "Counter", "Awaken", "Activate-Main", "Activate-Battle",
        "Barrier", "Critical", "Super-Combo", "Counter-Play", "Blocker",
        "Swap_2", "Swap_3", "Swap_4", "Swap_5", "Dark-Over-Realm", "Over-Realm",
        "Over-Realm_4", "Over-Realm_3", "Over-Realm_2", "Over-Realm_5", "Dual-Attack",
        "Energy-Exhaust", "Once-per-turn", "Arrival_Red-Green", "Awaken_Surge",
        "Counter-Counter", "Counter-Attack", "Arrival_Red-Yellow", "Offering",
        "Victory-Strike",
        "UNISON_plus-minus_00",
        "UNISON_plus_01",
        "UNISON_plus_02",
        "UNISON_minus_01",
        "UNISON_minus_02",
        "UNISON_minus_03",
        "UNISON_minus_04",
        "UNISON_minus_05",
        "UNISON_minus_06",
        "UNISON_minus_07",
        "Burst_2",
        "Burst_3",
        "Burst_5",
        "Revenge",
        "Triple-Attack",
        "Double-Strike",
        "Quadruple-Strike",
        "one",
        "two",
        "Activate_Main-Battle",
        "Sparking_3",
        "Sparking_5",
        "Sparking_7",
        "Alliance_Red-Green",
        "Aegis_Blue-Yellow",
        "Revive_Blue-Green",
        "Invoker",
        "Union",
        "Successor",
        "Swap",
        "Swap_2",
        "Swap_3",
        "Swap_4",
        "Swap_5",
        "Swap_6",
        "Union-Fusion",
        "Servant",
        "Unique",
        "Overlord",
        "Activate_Main-Battle",
        "Field",
        "Over-Realm-6",
        "Ultimate",
        "Wish",
        "Union-Potara",
        "Indestructible",
        "Aegis",
        "Arrival_Blue-Yellow",
        
    ].each do |str|
        path = Rails.root.join('public', 'images', "#{str}.png")
      if File.file?(path)
        puts "image exist skip"
      else
        File.open(Rails.root.join('public', 'images', "#{str}.png"), 'wb') do |fo|
          fo.write open("http://www.dbs-cardgame.com/images/cardlist/common/#{str}.png").read
        end
      end
    end

    # Card.all.each do |card|
    #   path = Rails.root.join('public', 'images', "#{card.number}.png")
    #   puts "card id: #{card.id}"
    #
    #   if File.file?(path)
    #     puts "image exist skip"
    #   else
    #     File.open(path, 'wb') do |fo|
    #       puts "downloading"
    #       fo.write open("http://www.dbs-cardgame.com/images/cardlist/cardimg/#{card.number}.png").read
    #   end
    #   end
    # end
  end
end