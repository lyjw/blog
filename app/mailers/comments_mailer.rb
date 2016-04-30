class CommentsMailer < ApplicationMailer

  def notify_post_owner(comment)
    @comment  = comment
    @user     = comment.user
    @post     = comment.post
    @owner    = @post.user

    return unless @owner

    mail(to: @owner.email, subject: "#{@user.full_name} commented on your post: #{@post.title}")
  end

  def send_daily_summary_report(user)
    @user = user
    user_post_comments = Comment.where("post_id IN (?)", user.posts.ids)
    @comments = user_post_comments.where("created_at > ? AND created_at < ?", DateTime.now.at_beginning_of_day.utc, DateTime.now.at_end_of_day.utc)

    mail(to: @user.email, subject: "#{@user.full_name} - #{@comments.count} new comments today")
  end

end
