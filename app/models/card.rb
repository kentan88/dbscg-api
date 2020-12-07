class Card < ApplicationRecord
  self.inheritance_column = :_type_disabled

  scope :leaders, -> { where(type: "LEADER") }
  scope :battles, -> { where(type: "BATTLE") }
  scope :extras, -> { where(type: "EXTRA") }
  scope :unisons, -> { where(type: "UNISON") }
end
