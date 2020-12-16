class API::LandingController < ApplicationController
  def index
    trending = Info.last.trending

    render json: { trending: trending }
  end
end