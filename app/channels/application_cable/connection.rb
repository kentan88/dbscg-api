module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
    def find_verified_user
      user_id = JWT.decode(request.params["token"], "secret", false)[0]["id"]

      if verified_user = User.find(user_id)
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
