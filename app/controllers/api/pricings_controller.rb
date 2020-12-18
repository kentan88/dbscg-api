class API::PricingsController < ApplicationController
  def index
    products = Info.first.pricing

    deck_id = params[:deck_id]
    if deck_id.present?
      deck = Deck.find(deck_id)
      main_deck_cards = deck.main_deck_cards
      card_numbers = main_deck_cards.collect { |number, v| number }.concat(deck.side_deck_cards.collect { |number, v| number }).uniq
      products = products.filter { |product| card_numbers.include?(product["number"]) }
      products = products.map { |product| product.merge({ quantity: main_deck_cards[product["number"]] })}
    end

    render json: { products: products }
  end
end