class API::CardsController < ApplicationController
  def index
    @cards = Card.all

    # q = Card.order(energy_cost: :asc, title: :asc).ransack(params[:q])
    # @cards = q.result(distinct: true).page(params[:page]).per(25)

    # result_hash = {}
    # @cards.each do |card|
    #   result_hash[card.number] = card.as_json.reject { |key| key == "skills" || key == "skills_back" }
    # end
    #
    # render json: result_hash
  end
end