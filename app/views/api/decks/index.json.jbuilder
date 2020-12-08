json.decks @decks do |deck|
  json.id deck.id
  json.name deck.name
  json.leader_number deck.leader_number
  json.description deck.description
  json.leader "#{deck.leader_card.title} / #{deck.leader_card.title_back}"
  json.created_by deck.user.username
  json.updated_at deck.updated_at.strftime("%F")

  json.cards deck.deck_cards do |deck_card|
    json.number deck_card.number
    json.quantity deck_card.quantity
    json.type deck_card.type
  end
end

json.partial! 'shared/pagination', collection: @decks
