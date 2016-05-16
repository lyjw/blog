class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all

    if params[:search]
        @found_posts = Post.search(params[:search]).order("created_at DESC")
      else
        @posts = Post.all.order('created_at DESC')

        if @posts.count > 10
          @posts = Post.page(params[:page]).per(5)
        end
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params
    @post.user = current_user

    if @post.save
      redirect_to post_path(@post), notice: "Post created."
    else
      flash[:alert] = "Invalid. Post was not created."
      render :new
    end
  end

  def show
    @comment = Comment.new
  end

  def edit
    redirect_to post_path(@post), alert: "Access Denied" unless can? :edit, @post
  end

  def update
    redirect_to post_path(@post), alert: "Access Denied" unless can? :update, @post

    if @post.update post_params
      redirect_to post_path(@post), notice: "Post updated."
    else
      flash[:alert] = "Invalid. Post was not updated."
      render :edit
    end
  end

  def destroy
    redirect_to post_path(@post), alert: "Access Denied" unless can? :destroy, @post

    @post.destroy
    flash[:alert] = "Post deleted."
    redirect_to posts_path
  end

  private

  def find_post
    @post = Post.find params[:id]
  end

  def post_params
    params.require(:post).permit([:title,
                                  :body,
                                  :category_id,
                                  tag_ids: []])
  end

end
