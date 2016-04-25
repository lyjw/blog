class Favourite < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :post_id, uniqueness: { scope: :user_id }

  def post_title
    Post.find(post_id).title
  end

  def post_author
    Post.find(post_id).author
  end

end
