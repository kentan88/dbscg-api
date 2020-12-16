class Card < ApplicationRecord
  self.inheritance_column = :_type_disabled

  has_many :pricings, foreign_key: :card_number, primary_key: :number

  validates :number, uniqueness: true

  scope :leaders, -> { where(type: "LEADER") }
  scope :battles, -> { where(type: "BATTLE") }
  scope :extras, -> { where(type: "EXTRA") }
  scope :unisons, -> { where(type: "UNISON") }
end
