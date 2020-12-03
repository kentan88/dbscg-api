class API::AlbumsController < ApplicationController
  before_action :extract_user_id_from_token, only: [:update]

  def update
    @album = Album.find_by(user_id: @user_id)
    @album.data = params[:album][:data]
    @album.save
  end
end