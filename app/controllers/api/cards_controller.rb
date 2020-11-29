class API::CardsController < ApplicationController
  def index
    # @q = Card.order(energy_cost: :asc, title: :asc).ransack(params[:q])
    # @cards = @q.result(distinct: true).page(params[:page]).per(25)
    #
    #
    @cards = Card.all.page(1).per(10000)
  end
end