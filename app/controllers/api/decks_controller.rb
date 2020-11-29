class API::DecksController < ApplicationController
  def index
    user_id = extract_user_id_from_token

    q =
        if params[:me].present? && user_id.present?
          Deck.includes(:user, :leader_card).where(user_id: user_id)
        else
          Deck.includes(:user, :leader_card)
        end

    q = q.order(updated_at: :desc).ransack(params[:q])
    @decks = q.result(distinct: true).page(params[:page]).per(25)
  end

  def show
    @deck = Deck.includes(deck_cards: [:card]).find(params[:id])
  end

  def create
    user_id = extract_user_id_from_token

    @deck = Deck.new(deck_params)
    @deck.user_id = user_id

    params[:deck][:deck_cards].each do |_key, value|
      card_id = value["id"]
      quantity = value["quantity"]
      @deck.deck_cards.new(card_id: card_id, quantity: quantity)
    end

    @deck.save
  end

  def deck_params
    params.require(:deck).permit(:name, :description, :card_id)
  end

  private

  def extract_user_id_from_token
    JWT.decode(user_token, "secret", false)[0]["id"] rescue nil
  end

  def user_token
    request.headers["Authorization"].split(" ")[1]
  end
end