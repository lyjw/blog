class CommentsMailer < ApplicationMailer

  def notify_post_owner(comment)
    @comment  = comment
    @user     = comment.user
    @post     = comment.post
    @owner    = @post.user

    return unless @owner

    mail(to: @owner.email, subject: "#{@user.full_name} commented on your post: #{@post.title}")
  end

end
