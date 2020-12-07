class API::DecksController < ApplicationController
  before_action :extract_user_id_from_token

  def index
    deck = Deck.includes(:user, :leader_card)
    q =
        if params[:me].present? && @user_id.present?
          deck.where(user_id: @user_id)
        else
          deck.make_public
        end

    q = q.order(updated_at: :desc).ransack(params[:q])
    @decks = q.result(distinct: true).page(params[:page]).per(25)
  end

  def show
    @deck = Deck.includes(:deck_cards).find(params[:id])
  end

  def create
    @deck = Deck.new(deck_params)
    @deck.user_id = @user_id
    @deck.leader_card = Card.find_by(number: params[:deck][:leader_card_number])
    build_deck_cards
    @deck.save
  end

  def modify
    @deck = Deck.find(params[:id])

    if @deck.user_id != @user_id
      render :status => 400, :json => {:message => 'Unauthorized'}
      return
    end

    @deck.leader_card = Card.find_by(number: params[:deck][:leader_card_number])
    @deck.deck_cards.delete_all
    @deck.name = params[:deck][:name]
    @deck.description = params[:deck][:description]
    build_deck_cards
    @deck.save
  end

  def clone
    clone_deck = Deck.find(params[:id])
    @deck = clone_deck.deep_clone except: :user_id, include: [:deck_cards]
    @deck.name = "[CLONED] #{@deck.name}" unless @deck.name.include?("[CLONED]")
    @deck.user_id = @user_id
    @deck.save
  end

  def make_public_private
    @deck = Deck.find(params[:id])

    if @deck.user_id != @user_id
      render :status => 400, :json => {:message => 'Unauthorized'}
      return
    end

    @deck.update_column(:private, !@deck.private)
  end

  def destroy
    @deck = Deck.find(params[:id])

    if @deck.user_id != @user_id
      render :status => 400, :json => {:message => 'Unauthorized'}
      return
    end

    @deck.destroy
  end

  private
  def build_deck_cards
    params[:deck][:deck_cards].each do |deck_card|
      @deck.deck_cards.new(
          number: deck_card["number"],
          quantity: deck_card["quantity"]
      )
    end
  end

  def deck_params
    params.require(:deck).permit(:name, :description)
  end
end