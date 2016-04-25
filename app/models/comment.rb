class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :body, presence: true

  def author
    user ? user.full_name : "Anonymous"
  end
end
