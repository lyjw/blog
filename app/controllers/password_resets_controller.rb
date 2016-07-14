class PasswordResetsController < ApplicationController
  layout "home"

  def new
  end

  def create
    user = User.find_by_email params[:email]

    if user
      user.generate_password_reset_data
      PasswordResetsMailer.send_instructions(user).deliver_now
    else
      redirect_to new_password_reset_path, alert: "Please enter a valid email address or sign up for an account."
    end
  end

  def edit
    @user = User.find_by_password_reset_token! params[:id]
    @password = PasswordReset.new
  end

  def update
    @user = User.find_by_password_reset_token! params[:id]
    user_params = params.require(:user).permit([:password, :password_confirmation])
    @password = PasswordReset.new(user_params)

    if @user.password_reset_expired?
      redirect_to new_password_reset_path, alert: "Password Reset expired. Please try again."
    elsif @password.valid? && @user.update(user_params)
      redirect_to new_session_path, notice: "Password was reset successfully. Please sign in."
    else
      render :edit
    end

  end

end
