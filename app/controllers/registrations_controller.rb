class RegistrationsController < ApplicationController
  include CurrentUserConcern

  def create
    user = User.create(user_params)

    if user.valid?
      session[:user_id] = user.id
      render json: {
        status: :created,
        user_logged_in: true,
        user: user,
        message: "You have successfully registered an account."
      }
    else
      render json: {
        status: 422,
        user_logged_in: false,
        message: user.errors.full_messages.first
      }
    end
  end

  def update
    user = User.find(params["id"])

    if @current_user && user.update(user_params)
      render json: {
        status: :updated,
        user_logged_in: true,
        user: user
      }
    else
      render json: { status: 500 }
    end
  end

  def destroy
    user = User.find(params["id"])

    if @current_user && user.destroy
      reset_session
      set_current_user
      render json: {
        status: :destroyed,
        user_logged_in: false,
        user: nil
      }
    else
      render json: { status: 500 }
    end
  end

  private

  def user_params
    {
      email: params["user"]["email"],
      password: params["user"]["password"],
      password_confirmation: params["user"]["password_confirmation"]
    }
  end
end
