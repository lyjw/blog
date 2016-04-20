class Category < ActiveRecord::Base
  belongs_to :post

  validates :title, presence: true, uniqueness: true

end
