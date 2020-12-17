class API::PricingsController < ApplicationController
  def index
    info = Info.first
    products = info.pricing

    render json: { products: products }
  end
end