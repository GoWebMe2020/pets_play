class SessionsController < ApplicationController
  protect_from_forgery
  def create
    # The :authenticate mehtod is bult in because we used `has_secure_password` in the User model.
    # This is built in Rails Magic
    user = User.find_by(email: params["user"]["email"]).try(:authenticate, params["user"]["password"])

    if user
      session[:user_id] = user.id
      render json: {
        status: :created,
        user_logged_in: true,
        user: user
      }
    else
      render json: { status: 401 }
    end
  end

end
