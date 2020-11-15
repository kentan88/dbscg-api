json.decks do
  json.array! @decks do |deck|
    json.id deck.id
    json.name deck.name
    json.leader deck.leader_card.title
    json.updated_at deck.updated_at.strftime("%F")
  end
end

json.partial! 'shared/pagination', collection: @decks
