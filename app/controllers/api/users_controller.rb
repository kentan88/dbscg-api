class API::UsersController < ApplicationController
  before_action :extract_user_id_from_token, only: [:info]

  def info
    @user = User.find(@user_id) if @user_id
    cards = Card.where.not(rating: 0)
    ratings = Hash[cards.collect { |item| [item.number, item.rating] } ]
    album = @user.try(:album).try(:data)

    render json: { ratings: ratings, album: album }
  end
end