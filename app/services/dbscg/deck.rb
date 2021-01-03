module DBSCG
  class Deck
    attr_accessor :leader, :cards

    def initialize(deck)
      cards = deck.main_deck_cards.reduce([]) do |acc , object|
        acc << object[1].times.map { |_n| DBSCG::Card.new(number: object[0]) }
      end.flatten

      @cards = cards
      @leader = DBSCG::Card.new(number: deck.leader_number)
    end

    def shuffle
      @cards.shuffle!
    end

    def draw(n = 1)
      @cards.shift(n)
    end

    def put_to_top(card)
      @cards.unshift(card)
    end

    def put_to_bottom(card)
      @cards.push(card)
    end
  end
end