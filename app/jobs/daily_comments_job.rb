class DailyCommentsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    user = Users.all

    @users.each do |user|
      CommentsMailer.send_daily_summary_report(user).deliver_now
    end
  end
end
