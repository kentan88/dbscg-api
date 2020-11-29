json.leaders @leaders do |leader|
  json.id leader.id
  json.card_id leader.card_id
  json.card_number leader.number
  json.title leader.title
  json.title_back leader.title_back
  json.power leader.power
  json.power_back leader.power_back
  json.number leader.number
end

json.partial! 'shared/pagination', collection: @decks