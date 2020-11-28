class Deck < ApplicationRecord
  belongs_to :user
  belongs_to :leader_card, class_name: "Card", foreign_key: :card_id
  has_many :deck_cards, dependent: :delete_all
  has_many :cards, through: :deck_cards

  validates :name, presence: true
  validates_associated :deck_cards
end
