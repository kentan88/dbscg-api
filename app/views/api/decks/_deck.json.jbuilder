json.id deck.id
json.name deck.name
json.private deck.private
json.description deck.description
json.can_modify @user_id == deck.user_id
json.can_delete @user_id == deck.user_id
json.can_toggle_public_private @user_id == deck.user_id
json.leader_number deck.leader_number
json.main_deck_cards deck.main_deck_cards
json.side_deck_cards deck.side_deck_cards