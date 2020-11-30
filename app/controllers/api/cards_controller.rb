class API::CardsController < ApplicationController
  # def index
  #   q = Card.order(energy_cost: :asc, title: :asc).ransack(params[:q])
  #   @cards = q.result(distinct: true).page(params[:page]).per(25)
  # end

  def ratings
    cards = Card.where.not(rating: 0)
    ratings = Hash[cards.collect { |item| [item.id, item.rating] } ]

    render json: { ratings: ratings }
  end
end