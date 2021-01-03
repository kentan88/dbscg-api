module DBSCG
  class Game
    include ActiveModel::Model

    validates :player_1, presence: true
    validates :player_2, presence: true
    validates :deck_1, presence: true
    validates :deck_2, presence: true

    attr_reader :player_1, :player_2
    attr_accessor :turn

    def initialize(player_1, deck_1, player_2, deck_2)
      @player_1 = DBSCG::Player.new(player_1, deck_1)
      @player_2 = DBSCG::Player.new(player_2, deck_2)
      @turn = [@player_1.username, @player_2.username].shuffle
      @resolve_chain = []
    end

    def end_turn
      @turn.reverse!
    end
  end
end

# player_1 = DBSCG::Player.new("kentan", 4)
# player_2 = DBSCG::Player.new("holycow", 6)
# game = DBSCG::Game.new(player_1, player_2)
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