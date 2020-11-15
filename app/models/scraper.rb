require 'nokogiri'
require 'watir'
require 'byebug'
require 'awesome_print'
require 'json'

SERIES_LIST = [
    {
        title: "DBS-B11-Booster-Vermilion-Bloodline",
        series: "DBS-B11",
        category: "428011"
    },
    {
        title: "DBS-B10-Booster-Rise-Of-The-Unison-Warrior",
        series: "DBS-B10",
        category: "428010"
    },
    {
        title: "DBS-B09-Universal-Onslaught",
        series: "DBS-B09",
        category: "428009"
    },
    {
        title: "DBS-B08-Malicious-Machinations",
        series: "DBS-B08",
        category: "428008"
    },
    {
        title: "DBS-B07-Assault-Of-The-Saiyans",
        series: "DBS-B07",
        category: "428007"
    },
    {
        title: "DBS-B06-Destroyer-Kings",
        series: "DBS-B06",
        category: "428006"
    },
    {
        title: "DBS-B05-Miraculous-Revival",
        series: "DBS-B05",
        category: "428005"
    },
    {
        title: "DBS-B04-Colossal-Warfare",
        series: "DBS-B04",
        category: "428004"
    },
    {
        title: "DBS-B03-Cross-Worlds",
        series: "DBS-B03",
        category: "428003"
    },
    {
        title: "DBS-B02-Union-Force",
        series: "DBS-B02",
        category: "428002"
    },
    {
        title: "DBS-B01-Galactic-Battle",
        series: "DBS-B01",
        category: "428001"
    },

    {
        title: "DBS-TB03-Clash-Of-Fates",
        series: "DBS-TB03",
        category: "428103"
    },
    {
        title: "DBS-TB02-World-Martial-Arts-Tournament",
        series: "DBS-TB02",
        category: "428102"
    },
    {
        title: "DBS-TB01-The-Tournament-Of-Power",
        series: "DBS-TB01",
        category: "428101"
    },
    {
        title: "DBS-Draft-Box-06-Giant-Force",
        series: "Draft-Box-06",
        category: "428603"
    },
    {
        title: "DBS-Draft-Box-05-Divine-Multiverse",
        series: "Draft-Box-05",
        category: "428602"
    },
    {
        title: "DBS-Draft-Box-04-Dragon-Brawl",
        series: "Draft-Box-04",
        category: "428601"
    },
    {
        title: "DBS-SD14-Saiyan Wonder",
        series: "DBS-SD14",
        category: "428314"
    }
]

class Scraper
  def cards
    SERIES_LIST.each do |series|
      puts "Seeding #{series[:title]}..."

      url = "http://www.dbs-cardgame.com/asia/cardlist/?search=true&category=#{series[:category]}"
      browser = Watir::Browser.new(:chrome, headless: true)
      browser.goto(url)
      doc = Nokogiri::HTML.parse(browser.html)

      card_list = []
      list = doc.css('.list-inner li')

      list.each do |nodes|
        card = {}
        cards_front = nodes.css('.cardFront')
        cards_back = nodes.css('.cardBack')

        cards_front.each do |card_front_nodes|
          number_nodes = card_front_nodes.css('.cardNumber')
          title_nodes = card_front_nodes.css('.cardName')
          series_nodes = card_front_nodes.css('.seriesCol')
          rarity_nodes = card_front_nodes.css('.rarityCol')
          type_nodes = card_front_nodes.css('.typeCol')
          color_nodes = card_front_nodes.css('.colorCol')
          power_nodes = card_front_nodes.css('.powerCol')
          energy_nodes = card_front_nodes.css('.energyCol')
          combo_energy_nodes = card_front_nodes.css('.comboEnergyCol')
          combo_power_nodes = card_front_nodes.css('.comboPowerCol')
          character_nodes = card_front_nodes.css('.characterCol')
          special_trait_nodes = card_front_nodes.css('.specialTraitCol')
          era_nodes = card_front_nodes.css('.eraCol')
          skill_nodes = card_front_nodes.css('.skillCol')

          number = number_nodes.inner_text
          title = title_nodes.inner_text
          series_list = series_nodes.children[3].inner_html.split("<br>")
          rarity = rarity_nodes.children[3].inner_text
          type = type_nodes.children[3].inner_text
          color = color_nodes.children[3].inner_text

          card.merge!({
              title: title,
              number: number,
              series: series_list,
              rarity: rarity,
              type: type,
              color: color
          })

          card['power'] = power_nodes.children[3].inner_text if power_nodes.children.length > 0
          if energy_nodes.children.length > 0
            energy_inner_html = energy_nodes.children[3].inner_html
            card['energy'] = {
                total: energy_inner_html.scan(/^[0-9]*/)[0],
                red: energy_inner_html.scan(/red/).count,
                green: energy_inner_html.scan(/green/).count,
                blue: energy_inner_html.scan(/blue/).count,
                yellow: energy_inner_html.scan(/yellow/).count,
                black: energy_inner_html.scan(/black/).count
            }
          end
          card['combo_energy'] = combo_energy_nodes.children[3].inner_html if combo_energy_nodes.children.length > 0
          card['combo_power'] = combo_power_nodes.children[3].inner_html if combo_power_nodes.children.length > 0
          card['character'] = character_nodes.children[3].inner_text if character_nodes.children.length > 0
          card['special_trait'] = special_trait_nodes.children[3].inner_text if special_trait_nodes.children.length > 0
          card['era'] = era_nodes.children[3].inner_text if era_nodes.children.length > 0
          card['skill'] = skill_nodes.children[3].inner_html if skill_nodes.children.length > 0
          card_list << card
        end

        cards_back.each do |card_back_nodes|
          title_back_nodes = card_back_nodes.css('.cardName')
          skill_back_nodes = card_back_nodes.css('.skillCol')

          if cards_back.length > 0
            card['title_back'] = title_back_nodes.inner_text
            card['skill_back'] = skill_back_nodes.children[3].inner_html if skill_back_nodes.children.length > 0
          end
        end
      end

      File.open("public/data/#{series[:title]}.json", "w") do |f|
        f.write(JSON.pretty_generate(card_list))
      end
    end
  end
end

scrape = Scraper.new
scrape.cards