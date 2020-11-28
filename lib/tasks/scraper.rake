require 'nokogiri'
require 'watir'
require 'json'
require "open-uri"

namespace :scraper do
  task :seed => :environment do
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
        },
        {
            title: "DBS-SD13-Clan Collusion",
            series: "DBS-SD13",
            category: "428313"
        },
        {
            title: "DBS-SD12-Spirit-Of-Potara",
            series: "DBS-SD12",
            category: "428312"
        },
        {
            title: "DBS-SD11-Instinct-Surpassed",
            series: "DBS-SD11",
            category: "428311"
        },
        {
            title: "DBS-SD10-Parasitic-Overlord",
            series: "DBS-SD10",
            category: "428310"
        },
        {
            title: "DBS-SD09-Saiyan-Legacy",
            series: "DBS-SD09",
            category: "428309"
        },
        {
            title: "DBS-SD08-Rising-Broly",
            series: "DBS-SD08",
            category: "428308"
        },
        {
            title: "DBS-SD07-Shenron's-Advent",
            series: "DBS-SD07",
            category: "428307"
        },
        {
            title: "DBS-SD06-Resurrected-Fusion",
            series: "DBS-SD06",
            category: "428306"
        },
        {
            title: "DBS-SD05-The-Crimson-Saiyan",
            series: "DBS-SD05",
            category: "428305"
        },
        {
            title: "DBS-SD04-The-Guardian-of-Namekians",
            series: "DBS-SD04",
            category: "428304"
        },
        {
            title: "DBS-SD03-The-Dark-Invasion",
            series: "DBS-SD03",
            category: "428303"
        },
        {
            title: "DBS-SD02-The-Extreme-Evolution",
            series: "DBS-SD02",
            category: "428302"
        },
        {
            title: "DBS-SD01-The-Awakening",
            series: "DBS-SD01",
            category: "428301"
        },
        {
            title: "DBS-XD03-The-Ultimate-Life-Form",
            series: "DBS-XD03",
            category: "428503"
        },
        {
            title: "DBS-XD02-Android-Duality",
            series: "DBS-XD02",
            category: "428502"
        },
        {
            title: "DBS-XD01-Universe-6-Assailants",
            series: "DBS-XD01",
            category: "428501"
        },
        {
            title: "DBS-Expansion-15-Battle-Enhanced",
            series: "DBS-Expansion-Set-15",
            category: "428415"
        },
        {
            title: "DBS-Expansion-14-Battle-Advanced",
            series: "DBS-Expansion-Set-14",
            category: "428414"
        },
        {
            title: "DBS-Expansion-12-Universe-11-Unison",
            series: "DBS-Expansion-Set-12",
            category: "428412"
        },
        {
            title: "DBS-Expansion-11-Universe-7-Unison",
            series: "DBS-Expansion-Set-11",
            category: "428411"
        },
        {
            title: "DBS-Expansion-10-Namekian-Surge",
            series: "DBS-Expansion-Set-10",
            category: "428410"
        },
        {
            title: "DBS-Expansion-09-Saiyan-Surge",
            series: "DBS-Expansion-Set-09",
            category: "428409"
        },
        {
            title: "DBS-Expansion-Set-Magnificent-Collection-Forsaken-Warrior",
            series: "DBS-Expansion-Set-Magnificent-Collection-Forsaken-Warrior",
            category: "428408"
        },
        {
            title: "DBS-Expansion-Magnificent-Collection-Fusion Hero",
            series: "DBS-Expansion-Set-Magnificent-Collection-Fusion-Hero",
            category: "428407"
        },
        {
            title: "DBS-Special-Anniversary-Box-2020",
            series: "DBS-Special-Anniversary-Box-2020",
            category: "428413"
        },
        {
            title: "DBS-Special-Anniversary-Box",
            series: "DBS-Special-Anniversary-Box",
            category: "428406"
        },
        {
            title: "DBS-Expansion-05-Unity-of-Destruction",
            series: "DBS-Expansion-Set-05",
            category: "428405"
        },
        {
            title: "DBS-Expansion-04-Unity-of-Saiyans",
            series: "DBS-Expansion-Set-04",
            category: "428404"
        },
        {
            title: "DBS-Ultimate-Box",
            series: "DBS-Ultimate-Box",
            category: "428403"
        },
        {
            title: "DBS-Expansion-02-Dark-Demons-Villains",
            series: "DBS-Expansion-Set-02",
            category: "428402"
        },
        {
            title: "DBS-Expansion-01-Mighty-Heroes",
            series: "DBS-Expansion-Set-01",
            category: "428401"
        },
        {
            title: "DBS-Promotion-Cards",
            series: "DBS-Promotion-Cards",
            category: "428901"
        },
    ]

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
          skills_nodes = card_front_nodes.css('.skillCol')
          number = number_nodes.inner_text.strip
          title = title_nodes.inner_text
          series_list = series_nodes.children[3].inner_html.strip.gsub("～", "~").split("<br>").join(" ")
          rarity = rarity_nodes.children[3].inner_text.strip
          type = type_nodes.children[3].inner_text.strip
          color = color_nodes.children[3].inner_text.strip

          card.merge!({
                          title: title,
                          number: number,
                          series_text: series_list,
                          rarity: rarity,
                          type: type,
                          color: color,
                      })

          card['power'] = power_nodes.children[3].inner_text.strip if power_nodes.children.length > 0
          if energy_nodes.children.length > 0
            energy_inner_html = energy_nodes.children[3].inner_html.strip
            card['energy'] = {
                red: energy_inner_html.scan(/red/).count,
                green: energy_inner_html.scan(/green/).count,
                blue: energy_inner_html.scan(/blue/).count,
                yellow: energy_inner_html.scan(/yellow/).count,
                black: energy_inner_html.scan(/black/).count
            }

            card['energy_cost'] = energy_inner_html.scan(/^[0-9]*/)[0]
            card['energy_text'] = energy_inner_html.gsub("../../images/cardlist/common/", "/images/")
          end
          card['combo_energy'] = combo_energy_nodes.children[3].inner_html.strip if combo_energy_nodes.children.length > 0
          card['combo_power'] = combo_power_nodes.children[3].inner_html.strip if combo_power_nodes.children.length > 0
          card['character'] = character_nodes.children[3].inner_text.strip if character_nodes.children.length > 0
          card['special_trait'] = special_trait_nodes.children[3].inner_text.strip if special_trait_nodes.children.length > 0
          card['era'] = era_nodes.children[3].inner_text.strip if era_nodes.children.length > 0

          if skills_nodes.children.length > 0
            card['skills_text'] = skills_nodes.children[3].inner_html.strip.gsub("../../images/cardlist/common/", "/images/")
            card['skills'] = skills_nodes.children[3].inner_html.strip.scan(/[a-zA-Z-]+.png/).map { |str| str.gsub(".png", "") }.uniq
          end

          card_list << card
        end

        cards_back.each do |card_back_nodes|
          title_back_nodes = card_back_nodes.css('.cardName')
          skills_back_nodes = card_back_nodes.css('.skillCol')
          power_back_nodes = card_back_nodes.css('.powerCol')

          if cards_back.length > 0
            card['title_back'] = title_back_nodes.inner_text.strip

            if skills_back_nodes.children.length > 0
              card['power_back'] = power_back_nodes.children[3].inner_text.strip if power_back_nodes.children.length > 0
              card['skills_back_text'] = skills_back_nodes.children[3].inner_html.strip.gsub("../../images/cardlist/common", "/images")
              card['skills_back'] = skills_back_nodes.children[3].inner_html.strip.scan(/[a-zA-Z\-_]+.png/).map { |str| str.gsub(".png", "") }.uniq
            end
          end
        end
      end

      File.open("public/data/#{series[:title]}.json", "w") do |f|
        f.write(JSON.pretty_generate(card_list))
      end
    end
  end
end

