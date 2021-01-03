json.rooms @rooms do |room|
  json.id room.id
  json.player_1 room.player_1.try(:username)
  json.player_2 room.player_2.try(:username)
end