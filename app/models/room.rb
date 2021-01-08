class Room < ApplicationRecord
  belongs_to :player_1, class_name: "User", required: false
  belongs_to :player_2, class_name: "User", required: false

  belongs_to :player_1_deck, class_name: "Deck", required: false
  belongs_to :player_2_deck, class_name: "Deck", required: false

  attr_accessor :game

  def game=(value)
    @game = value
  end
end
