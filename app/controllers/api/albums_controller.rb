class API::AlbumsController < ApplicationController
  before_action :extract_user_id_from_token, only: [:update]

  def update
    @album = Album.find_by(user_id: @user_id)
    data = @album.data.as_json

    card_number = params[:card_number].to_s
    data[card_number] = !data[card_number]

    @album.data = data
    @album.update_column(:data, @album.data)
  end
end