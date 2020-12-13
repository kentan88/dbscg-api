class API::DecksController < ApplicationController
  before_action :extract_user_id_from_token

  def index
    deck = Deck.all
    q =
        if params[:me].present? && @user_id.present?
          deck.where(user_id: @user_id)
        else
          deck.not_draft.make_public
        end

    q = q.where.contains(colors: params[:q][:colors_contain]) if params[:q] && params[:q][:colors_contain]
    q = q.order(updated_at: :desc).ransack(params[:q])
    @decks = q.result(distinct: true).page(params[:page]).per(25)
  end

  def show
    @deck = Deck.find(params[:id])

    if @deck.user_id != @user_id && (@deck.private || @deck.draft)
      render status: 400, json: {message: 'Unauthorized'}
      return
    end
  end

  def create
    @deck = Deck.new(deck_params)
    user = User.find(@user_id)
    @deck.user_id = user.id
    @deck.username = user.username
    @deck.draft = @deck.main_deck_cards.inject(0) { |sum, tuple| sum += tuple[1] } < 50
    @deck.colors = get_colors(params[:deck][:data][:colors])
    @deck.save!
  end

  def modify
    @deck = Deck.find(params[:id])

    if @deck.user_id != @user_id
      render status: 400, json: {message: 'Unauthorized'}
      return
    end

    @deck.assign_attributes(deck_params)
    @deck.draft = @deck.main_deck_cards.inject(0) { |sum, tuple| sum += tuple[1] } < 50
    @deck.colors = get_colors(params[:deck][:data][:colors])
    @deck.save!
  end

  def clone
    clone_deck = Deck.find(params[:id])
    @deck = clone_deck.deep_clone except: :user_id
    @deck.name = "[CLONED] #{@deck.name}" unless @deck.name.include?("[CLONED]")
    @deck.user_id = @user_id
    @deck.save!
  end

  def make_public_private
    @deck = Deck.find(params[:id])

    if @deck.user_id != @user_id
      render status: 400, json: {message: 'Unauthorized'}
      return
    end

    @deck.update_column(:private, !@deck.private)
  end

  def destroy
    @deck = Deck.find(params[:id])

    if @deck.user_id != @user_id
      render status: 400, json: {message: 'Unauthorized'}
      return
    end

    @deck.destroy
  end

  private

  def get_colors(colors)
    colors.reject { |_k, v| v <= 0 }.keys.map { |color| color.split("/") }.flatten.uniq rescue []
  end

  def deck_params
    params.require(:deck).permit(
        :name,
        :leader_number,
        :description,
        main_deck_cards: {},
        side_deck_cards: {},
        data: {}
    )
  end
end