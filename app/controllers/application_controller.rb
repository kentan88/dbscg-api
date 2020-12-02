class ApplicationController < ActionController::API
  def extract_user_id_from_token
    @user_id = JWT.decode(user_token, "secret", false)[0]["id"] rescue nil
  end

  def user_token
    request.headers["Authorization"].split(" ")[1]
  end
end
