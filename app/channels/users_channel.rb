class UsersChannel < ApplicationCable::Channel

  def subscribed
    user_id = JWT.decode(params["token"], "secret", false)[0]["id"]

    @user = User.find(user_id)

    stream_from "user_#{@user.username}"
  end

  def unsubscribed
    # any cleanup needed when channel is unsubscribed
  end
end