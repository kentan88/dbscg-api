class Deck < ApplicationRecord
  ransacker :within_json do |parent|
    Arel.sql("decks.main_deck_cards::text")
  end

  belongs_to :user
  belongs_to :leader_card, class_name: "Card", foreign_key: :leader_number, primary_key: :number
  validates :name, presence: true

  scope :not_draft, -> { where(draft: false ) }
  scope :make_public, -> { where(private: false) }
  scope :make_private, -> { where(private: true) }

  def total_number_of_cards
    main_deck_cards.inject(0) { |sum, tuple| sum += tuple[1] }
  end
end
