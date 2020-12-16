namespace :cards do
  task :update_limit => :environment do
    cards = Card.all
    cards.update_all({limit: 4 })

    cards = Card.where(rarity: ['Special Rare Signature[SPR_S]', 'Special Rare[SPR]'])
    cards.update_all({limit: 1 })

    cards = Card.where("skills_text ILIKE '%You can include as many%'")
    cards.update_all({limit: 0 })

    cards = Card.where(title: [
        'Dragon Ball',
        'Super Dragon Ball',
        "Porunga's Dragon Ball",
        'One-Star Ball',
        'Two-Star Ball',
        'Three-Star Ball',
        'Five-Star Ball',
        'Six-Star Ball',
        'Seven-Star Ball',
    ])

    cards.update_all({limit: 7 })
  end

  task :special_traits => :environment do
    results = []
    all_special_traits = Card.all.collect(&:special_trait).compact.sort.uniq

    all_special_traits.each do |special_trait|
      split_special_traits = special_trait.split("/")

      split_special_traits.each do |split_special_trait|
        results << split_special_trait
      end
    end

    puts results.sort.uniq
  end

  task :dups => :environment do
    dups = []
    Card.all.each do |card|
      if !card.valid?
        dups << card.number
      end
    end

    dups.uniq.each do |number|
      card = Card.find_by(number: number)
      card.destroy
    end
  end
end