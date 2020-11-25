class API::DecksController < ApplicationController
  def index
    user_id = extract_user_id_from_token

    @decks =
        if params[:me].present? && user_id.present?
          Deck.includes(:user, :leader_card).where(user_id: user_id)
        else
          Deck.includes(:user, :leader_card)
        end

    @decks = @decks.order(updated_at: :desc).page(params[:page]).per(50)
  end

  def show
    @deck = Deck.includes(deck_cards: [:card]).find(params[:id])
  end

  def create
    user_id = extract_user_id_from_token

    @deck = Deck.new(deck_params)
    @deck.user_id = user_id

    params[:deck][:deck_cards].each do |key, value|
      card_id = value["id"]
      quantity = value["quantity"]
      @deck.deck_cards.new(card_id: card_id, quantity: quantity)
    end

    @deck.save
  end

  def deck_params
    params.require(:deck).permit(:name, :card_id)
  end

  private

  def extract_user_id_from_token
    JWT.decode(user_token, "secret", false)[0]["id"] rescue nil
  end

  def user_token
    puts request.headers["Authorization"]
    request.headers["Authorization"].split(" ")[1]
  end
end