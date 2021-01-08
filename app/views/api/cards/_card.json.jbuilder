json.number card.number
json.color card.color
json.title card.title
json.title_back card.title_back
json.type card.type
# json.rarity card.rarity
json.energy card.energy
# json.energy_text card.energy_text
json.combo_energy card.combo_energy
json.power card.power
json.power_back card.power_back
json.combo_power card.combo_power
json.character card.character
# json.special_trait card.special_trait
# json.era card.era
# json.series card.series
json.skills_text card.skills_text
json.skills_back_text card.skills_back_text
# json.limit card.limit

json.specified_energy card.energy_text ? card.energy_text.scan(/[a-zA-Z-_]+.png/).map { |str| str.gsub("_ball.png", "") }.join("|") : ""