class API::CardsController < ApplicationController
  def index
    @q = Card.order(title: :asc).ransack(params[:q])
    @cards = @q.result(distinct: true).page(params[:page]).per(50)

    # @cards = Card.page(params[:page]).per(50)
    # .uniq { |record| record.title }
  end
end