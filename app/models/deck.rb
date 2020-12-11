class Deck < ApplicationRecord
  belongs_to :user
  belongs_to :leader_card, class_name: "Card", foreign_key: :leader_number, primary_key: :number
  validates :name, presence: true

  scope :make_public, -> { where(private: false) }
  scope :make_private, -> { where(private: true) }
end
