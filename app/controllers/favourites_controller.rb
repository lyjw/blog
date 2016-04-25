class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favourites = current_user.favourites
  end

  def create
    favourite       = Favourite.new
    favourite.post  = post
    favourite.user  = current_user

    if favourite.save
      redirect_to post_path(post), notice: "Added to Favourites"
    else
      redirect_to post_path(post), alert: "Already favourited."
    end
  end

  def destroy
    favourite = current_user.favourites.find params[:id]
    favourite.destroy
    redirect_to post_path(post), notice: "Removed from Favourites"
  end


  private

  def post
    @post = Post.find params[:post_id]
  end

end
