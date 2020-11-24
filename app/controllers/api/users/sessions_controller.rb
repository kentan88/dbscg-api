# frozen_string_literal: true

class API::Users::SessionsController < Devise::SessionsController
  before_action :authenticate_with_token!, except: [:create]
  before_action :ensure_params_exist
  respond_to :json

  def create
    resource = User.find_for_database_authentication(
        username: params[:user][:username]
    )
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      token = JWT.encode resource.as_json, "secret", 'none'
      render(status: 200, json: { token: token })

      return
    end
    invalid_login_attempt
  end

  def destroy
    resource = current_user
    resource.authentication_token = nil
    resource.save
    head 204
  end


  protected
  def ensure_params_exist
    return unless params[:user].blank?
    render json: {
        success: false,
        message: "missing user parameter"
    }, status: 422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render json: {
        success: false,
        message: "Error with your email or password"
    }, status: 401
  end

end
