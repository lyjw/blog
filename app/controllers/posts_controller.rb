class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def index
    @found_posts = []
    @posts = Post.all

    if params[:search_term] && params[:search_term] != ""
      @found_posts = Post.search(params[:search_term]).order('title')
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to post_path(@post), notice: "Post created."
    else
      flash[:alert] = "Invalid. Post was not created."
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update post_params
      redirect_to post_path(@post), notice: "Post updated."
    else
      flash[:alert] = "Invalid. Post was not updated."
      render :edit
    end
  end

  def destroy
    @post = Post.find params[:id]
    @post.delete
    flash[:alert] = "Post deleted."
    redirect_to posts_path
  end

  private

  def find_post
    @post = Post.find params[:id]
  end

  def post_params
    params.require(:post).permit([:title, :body])
  end

end
