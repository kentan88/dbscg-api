class API::LandingController < ApplicationController
  def index
    info = Info.first

    render json: { trending: info.trending }
  end
end