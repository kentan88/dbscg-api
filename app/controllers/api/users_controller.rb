class API::UsersController < ApplicationController
  before_action :extract_user_id_from_token, only: [:info]

  def info
    @user = User.find(@user_id) if @user_id rescue nil
    album = @user.album.data || {}
    ratings = Info.first.ratings

    render json: { album: album, ratings: ratings }
  end
end