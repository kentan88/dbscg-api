namespace :cards do
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