module DBSCG
  class Player
    attr_reader :username
    attr_accessor :deck, :hand, :drop, :life, :warp

    def initialize(user, deck)
      @username = user.username
      @deck = DBSCG::Deck.new(deck)
      @hand = DBSCG::Hand.new({ cards: [] })
      @drop = []
      @life = []
      @warp = []
    end

    def draw_to_hand(n = 1)
      cards = @deck.cards.shift(n)
      @hand.concat(cards)
    end
  end
end