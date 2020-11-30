json.cards do
  json.array! @cards, partial: 'api/cards/card', as: :card
end

# json.partial! 'shared/pagination', collection: @cards
