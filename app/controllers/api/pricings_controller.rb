class API::PricingsController < ApplicationController
  def index
    info = Info.first
    pricing = info.pricing.reject { |pricing| pricing["marketPrice"] == nil }

    render json: { pricing: pricing }
  end
end