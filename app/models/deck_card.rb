class DeckCard < ApplicationRecord
  self.inheritance_column = :_type_disabled
  belongs_to :deck
  belongs_to :card, primary_key: "number", foreign_key: "number", required: false
end
