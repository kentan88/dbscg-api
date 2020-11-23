# frozen_string_literal: true
# https://gist.github.com/esteedqueen/a50fee0b83d13326f9a0

class API::Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json

  def create
    if params[:user][:email].nil?
      render :status => 400,
             :json => {:message => 'User request must contain the user email.'}
      return
    elsif params[:user][:password].nil?
      render :status => 400,
             :json => {:message => 'User request must contain the user password.'}
      return
    end

    if params[:user][:email]
      duplicate_user = User.find_by_email(params[:user][:email])
      unless duplicate_user.nil?
        render :status => 409,
               :json => {:message => 'Duplicate email. A user already exists with that email address.'}
        return
      end
    end

    @user = User.create(sign_up_params)

    if @user.save
      token = JWT.encode @user.as_json, "secret", 'none'
      render(status: 200, json: { token: token })
    else
      render :status => 400,
             :json => {:message => @user.errors.full_messages}
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :username, :password)
  end
end
