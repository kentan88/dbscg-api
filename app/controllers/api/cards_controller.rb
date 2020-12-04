class API::CardsController < ApplicationController
  before_action :extract_user_id_from_token, only: [:data]

  def index
    @cards = Card.all
    # q = Card.order(energy_cost: :asc, title: :asc).ransack(params[:q])
    # @cards = q.result(distinct: true).page(params[:page]).per(25)
  end

  def leaders
    @cards = Card.leaders.order({ rating: :desc, title: :asc })
  end
end