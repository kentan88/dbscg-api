class API::DecksController < ApplicationController
  def index
    @decks = Deck.page(params[:page]).per(50)
  end

  def show
    @deck = Deck.includes(deck_cards: [:card]).find(params[:id])
  end

  def create
    @deck = Deck.new(deck_params)

    # @deck.deck_cards = [DeckCard.new(card_id: 1000)]

    @deck.save
  end

  def deck_params
    params.require(:deck).permit(:title, :card_id)
  end
end