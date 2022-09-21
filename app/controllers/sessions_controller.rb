class SessionsController < ApplicationController
  include CurrentUserConcern

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

  def logged_in
    if @current_user
      render json: {
        user_logged_in: true,
        user: @current_user
      }
    else
      render json: {
        user_logged_in: false
      }
    end
  end

  def logout
    reset_session
    set_current_user
    render json: {
      status: 200,
      user_logged_in: false
    }
  end

end
