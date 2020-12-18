require 'httparty'
require 'json'

namespace :pricings do
  task :update => :environment do
    token_url = "https://api.tcgplayer.com/token"

    puts "Getting access token"
    payload = {
        grant_type: "client_credentials",
        client_id: "236ce72c-281e-403b-8f31-f4f59db72124",
        client_secret: "495ffe87-22aa-4e02-9786-ac45a7abcae8"
    }

    headers = { "Content-Type" => "application/json" }
    access_token = JSON.parse(HTTParty.post(token_url, { body: payload, headers: headers }).body)["access_token"]
    puts access_token

    version = "v1.39.0"
    limit = 100
    category_id = 27

    ###########
    ###########
    ###########
    ###########

    url = "http://api.tcgplayer.com/#{version}/catalog/products?categoryId=#{category_id}&getExtendedFields=true&limit=1"
    total_number_of_items = JSON.parse(HTTParty.get(url, headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{access_token}"
    }).body)["totalItems"]

    mapping_list = []
    product_ids = []
    (0...total_number_of_items).to_a.in_groups_of(limit) do |group|
      offset = group[0]
      url = "http://api.tcgplayer.com/#{version}/catalog/products?categoryId=#{category_id}&getExtendedFields=true&limit=#{limit}&offset=#{offset}"

      results = JSON.parse(HTTParty.get(url, headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{access_token}"
      }).body)

      cards = results["results"].filter { |data| data["extendedData"].find { |extended_data| extended_data["name"] == "Number" } }

      cards.each do |card|
        product_ids << card["productId"]
        card_number = card["extendedData"].find { |extended_data| extended_data["name"] == "Number" }["value"]
        mapping_list << {  "url" => card["url"], "number" => card_number, "productId" => card["productId"], "imageUrl" => card["imageUrl"], title: card["cleanName"] }
      end
    end

    ###########
    ###########
    ###########
    ###########

    pricing_list = []
    # data = JSON.parse(File.read("#{Rails.root}/public/pricing/mapping.json"))
    # product_ids = data.map { |product_id, v| product_id }

    product_ids.to_a.in_groups_of(limit) do |group|
      url = "http://api.tcgplayer.com/#{version}/pricing/product/#{group.join(',')}"
      results = JSON.parse(HTTParty.get(url, headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{access_token}"
      }).body)

      results["results"].each do |result|
        pricing_list << result
      end
    end

    final_pricing = mapping_list.map do |list|
      pricing = pricing_list.find { |pricing| pricing["productId"] == list["productId"] && pricing["subTypeName"] == "Normal"}
      list.merge({ pricing: pricing })
    end

    info = Info.first
    info.pricing = final_pricing
    info.tcg_mapping = nil
    info.save!
  end
end