class API::PricingsController < ApplicationController
  def index
    products = Info.first.pricing

    deck_id = params[:deck_id]
    if deck_id.present?
      deck = Deck.find(deck_id)
      card_numbers = deck.main_deck_cards.collect { |k, v| k }.concat(deck.side_deck_cards.collect { |k, v| k }).uniq
      products = products.filter { |pricing| card_numbers.include?(pricing["number"]) }
    end

    render json: { products: products }
  end
end