namespace :blog do
  task :email_daily_comments do
    DailyCommentsJob.perform_now
  end
end
