class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_post
  before_action :find_comment, only: [:edit, :update, :destroy]

  def create
    @comment        = Comment.new comment_params
    @comment.post   = @post
    @comment.user   = current_user

    if @comment.save
      CommentsMailer.notify_post_owner(@comment).deliver_later
      redirect_to post_path(@post), notice: "Comment created."
    else
      flash[:alert] = "Comment was not updated."
      render "/posts/show"
    end
  end

  def edit
  end

  def update
    if @comment.update comment_params
      redirect_to post_path(@post), notice: "Comment updated."
    else
      flash[:alert] = "Comment was not updated."
      render "/posts/show"
    end
  end

  def destroy
    @comment.destroy
    redirect_to post_path(@post), notice: "Comment deleted."
  end

  private

  def find_post
    @post = Post.find params[:post_id]
  end

  def find_comment
    @comment = @post.comments.find params[:id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
