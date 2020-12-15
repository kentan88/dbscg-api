class API::AlbumsController < ApplicationController
  before_action :extract_user_id_from_token, only: [:update]

  def update
    @album = Album.find_by(user_id: @user_id)

    unless @album.present?
      render status: 400, json: {message: 'Unauthorized'}
      return
    end

    data = @album.data.as_json || {}

    number = params[:number].to_s
    quantity = params[:quantity]
    data[number] = quantity || 1

    @album.data = data
    @album.update_column(:data, @album.data)

    render json: { number: number, quantity: quantity }
  end
end