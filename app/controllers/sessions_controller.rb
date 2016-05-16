class SessionsController < ApplicationController
  layout "home"

  def new
  end

  def create
    user = User.find_by_email params[:email]

    if user && user.authenticate(params[:password])
      sign_in(user)
      redirect_to user_path(user), notice: "Logged in"
    else
      flash[:alert] = "Wrong email or password. Please try again."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out."
  end
end
