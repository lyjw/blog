class UsersController < ApplicationController
  before_action :find_user, only: [:edit, :update, :change_password, :update_password]
  layout "home", only: [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      sign_in(@user)
      redirect_to root_path, notice: "User successfully created."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.authenticate(user_params[:password])

      if @user.update user_params
        redirect_to user_path(@user), notice: "Your profile was updated."
      else
        render :edit
      end

    else
      flash[:alert] = "Password incorrect. Profile was not updated."
      render :edit
    end
  end

  def change_password
  end

  def update_password
    if @user.authenticate(params[:password]) && params[:password] != params[:new_password]
      @user.password = params[:new_password]
      @user.save
      redirect_to user_path(@user), notice: "Your password was updated."
    elsif params[:password] == params[:new_password]
      flash[:alert] = "New password must be different from current password."
      render :change_password
    else
      flash[:alert] = "Password is incorrect. Password was not updated."
      render :change_password
    end
  end

  private

  def find_user
    @user = User.find current_user
  end

  def user_params
    params.require(:user).permit([:first_name, :last_name, :email, :password, :password_confirmation])
  end

end
