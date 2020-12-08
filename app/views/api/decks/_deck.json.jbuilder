json.deck do
  json.id deck.id
  json.name deck.name
  json.private deck.private
  json.description deck.description
  json.can_modify @user_id == deck.user_id
  json.can_delete @user_id == deck.user_id
  json.can_toggle_public_private @user_id == deck.user_id
end

json.leader_card do
  json.number deck.leader_number
end

json.cards deck.deck_cards do |deck_card|
  json.number deck_card.number
  json.quantity deck_card.quantity
  json.type deck_card.type
end