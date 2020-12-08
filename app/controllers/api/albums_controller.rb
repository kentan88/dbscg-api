class API::AlbumsController < ApplicationController
  before_action :extract_user_id_from_token, only: [:update]

  def update
    @album = Album.find_by(user_id: @user_id)

    unless @album.present?
      render :status => 400, :json => {:message => 'Unauthorized'}
      return
    end

    data = @album.data.as_json

    card_number = params[:card_number].to_s
    data[card_number] = !data[card_number]

    @album.data = data
    @album.update_column(:data, @album.data)

    render json: {success: true}
  end
end