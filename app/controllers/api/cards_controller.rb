class API::CardsController < ApplicationController
  def index
    @cards = Card.page(params[:page]).per(50)
    # .uniq { |record| record.title }
  end
end