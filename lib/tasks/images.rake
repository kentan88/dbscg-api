namespace :decks do
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
    ].each do |str|
      File.open(Rails.root.join('public', 'images', "#{str}.png"), 'wb') do |fo|
        fo.write open("http://www.dbs-cardgame.com/images/cardlist/common/#{str}.png").read
      end
    end

    Card.all.each do |card|
      File.open(Rails.root.join('public', 'images', "#{card.number}.png"), 'wb') do |fo|
        fo.write open("http://www.dbs-cardgame.com/images/cardlist/cardimg/#{card.number}.png").read
      end
    end
  end
end