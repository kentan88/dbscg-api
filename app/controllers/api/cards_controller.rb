class API::CardsController < ApplicationController
  before_action :extract_user_id_from_token, only: [:data]

  def index
    # q = Card.order(energy_cost: :asc, title: :asc).ransack(params[:q])
    # @cards = q.result(distinct: true).page(params[:page]).per(25)
  end

  def data
    cards = Card.where.not(rating: 0)
    ratings = Hash[cards.collect { |item| [item.number, item.rating] } ]
    album = Album.find_by(user_id: @user_id).data

    render json: { ratings: ratings, album: album }
  end

  def leaders
    @cards = Card.leaders.order({ rating: :desc, title: :asc })
  end
end