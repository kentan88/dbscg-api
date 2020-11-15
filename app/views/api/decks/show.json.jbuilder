json.deck do
  json.id @deck.id
  json.name @deck.name
  json.cards @deck.deck_cards do |deck_card|
    json.partial! deck_card.card, as: :card
    json.quantity deck_card.quantity
  end
end
