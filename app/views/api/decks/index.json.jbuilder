json.decks @decks do |deck|
  json.id deck.id
  json.name deck.name
  json.leader_number deck.leader_number
  json.created_by deck.username
  json.updated_at "#{time_ago_in_words(deck.updated_at)} ago"
  json.main_deck_cards deck.main_deck_cards
  json.side_deck_cards deck.side_deck_cards
  json.rating deck.rating
  json.colors deck.colors
end

json.partial! 'shared/pagination', collection: @decks
