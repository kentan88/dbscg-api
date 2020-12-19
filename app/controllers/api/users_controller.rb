class API::UsersController < ApplicationController
  before_action :extract_user_id_from_token

  def info
    @user = User.find(@user_id) if @user_id rescue nil
    ratings = Info.first.ratings

    render json: { ratings: ratings }
  end

  def album
    @user = User.find(@user_id) if @user_id rescue nil
    album = @user.album.data rescue {}

    render json: { album: album }
  end
end