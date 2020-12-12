class API::LandingController < ApplicationController
  def index
    trending = Info.first.trending

    render json: { trending: trending }
  end
end