class RemovePostIdAndCommentIdFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :post_id, :integer
    remove_column :posts, :comment_id, :integer
  end
end
