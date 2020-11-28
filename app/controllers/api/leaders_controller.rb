class API::LeadersController < ApplicationController
  def index
    @q = Leader.order(title: :asc).ransack(params[:q])
    @leaders = @q.result(distinct: true).page(params[:page]).per(25)
  end
end