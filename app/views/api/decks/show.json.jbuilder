json.deck do
  json.id @deck.id
  json.name @deck.name
end

json.leader_card do
  json.partial! @deck.leader_card, as: :card
end

json.cards @deck.deck_cards do |deck_card|
  json.partial! deck_card.card, as: :card
  json.quantity deck_card.quantity
end