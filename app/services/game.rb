class Game
  include ActiveModel::Model

  validates :player_1, presence: true
  validates :player_2, presence: true
  validates :deck_1, presence: true
  validates :deck_2, presence: true

  attr_reader :player_1, :player_2
  attr_accessor :turn

  def initialize(player_1, deck_1, player_2, deck_2)
    @player_1 = Player.new(player_1, deck_1)
    @player_2 = Player.new(player_2, deck_2)
    @turn = [@player_1.username, @player_2.username].shuffle
    @resolve_chain = []
  end

  def end_turn
    @turn.reverse!
  end

  class Player
    attr_reader :username
    attr_accessor :deck, :hand, :drop, :life, :warp

    def initialize(user, deck)
      @username = user.username
      @deck = Game::Deck.new(deck)
      @hand = []
      @drop = []
      @life = []
      @warp = []
    end

    def draw_to_hand(n = 1)
      cards = @deck.cards.shift(n)
      @hand.concat(cards)
    end
  end

  class Deck
    attr_accessor :leader, :cards

    def initialize(deck)
      cards = deck.main_deck_cards.reduce([]) do |acc , object|
        acc << object[1].times.map { |_n| Game::Card.new(number: object[0]) }
      end.flatten

      @cards = cards
      @leader = Game::Card.new(number: deck.leader_number)
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

  class Card
    attr_reader :number

    def initialize(opts)
      @number = opts[:number]
    end
  end
end

# player_1 = Game::Player.new("kentan", 4)
# player_2 = Game::Player.new("holycow", 6)
# game = Game.new(player_1, player_2)
#
# player_1.play_leader_card
# player_2.player_leader_card
#
# player_1.deck.shuffle
# player_2.deck.shuffle
# player_1.draw_to_hand(6)
# player_2.draw_to_hand(6)
# player_1.hand
# player_2.hand