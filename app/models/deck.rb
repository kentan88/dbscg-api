class Deck < ApplicationRecord
  belongs_to :user
  belongs_to :leader_card, class_name: "Card", foreign_key: :leader_number, primary_key: :number
  has_many :deck_cards, dependent: :delete_all
  has_many :cards, through: :deck_cards

  validates :name, presence: true
  validates_associated :deck_cards

  scope :make_public, -> { where(private: false) }
  scope :make_private, -> { where(private: true) }
end
