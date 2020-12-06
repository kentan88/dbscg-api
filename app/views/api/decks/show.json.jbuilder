json.deck do
  json.id @deck.id
  json.name @deck.name
  json.description @deck.description
end

json.leader_card do
  json.number @deck.leader_card.number
end

json.cards @deck.deck_cards do |deck_card|
  json.number deck_card.card.number
  json.quantity deck_card.quantity
end