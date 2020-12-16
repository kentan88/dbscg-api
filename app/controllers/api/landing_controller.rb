class API::LandingController < ApplicationController
  def index
    info = Info.first

    render json: { trending: info.trending, pricing: info.pricing }
  end
end