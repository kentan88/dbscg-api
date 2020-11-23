class API::DecksController < ApplicationController
  def index
    user_id = extract_user_id_from_token

    @decks =
        if params[:me].present? && user_id.present?
          Deck.includes(:leader_card).where(user_id: user_id)
        else
          Deck.includes(:leader_card)
        end

    @decks = @decks.page(params[:page]).per(50)
  end

  def show
    @deck = Deck.includes(deck_cards: [:card]).find(params[:id])
  end

  def create
    @deck = Deck.new(deck_params)
    @deck.save
  end

  def deck_params
    params.require(:deck).permit(:title, :card_id)
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