json.decks @decks do |deck|
  json.id deck.id
  json.name deck.name
  json.description deck.description
  json.leader deck.leader_card.title
  json.created_by deck.user.username
  json.updated_at deck.updated_at.strftime("%F")
end

json.partial! 'shared/pagination', collection: @decks
