class Pricing < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :card,  foreign_key: :card_number, primary_key: :number
end
