class API::RoomsController < ApplicationController
  before_action :extract_user_id_from_token

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
  end

  def create
    @room = Room.create!
  end
end