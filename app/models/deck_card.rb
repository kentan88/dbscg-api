class DeckCard < ApplicationRecord
  belongs_to :deck
  belongs_to :card, primary_key: "number", foreign_key: "number", required: false
end
