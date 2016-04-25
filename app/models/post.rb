class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :categories, dependent: :nullify
  belongs_to :user

  has_many :favourites, dependent: :destroy
  has_many :users, through: :favourites

  validates :title, presence: true, uniqueness: { case_insensitive: true }, length: { minimum: 7 }

  validates :body, presence: true

  def body_snippet
    body.length > 100 ? body[0..99].concat("...") : body
  end

  def category_name
    category_id ? Category.find(category_id).title : "N/A"
  end

  def author
    user ? user.full_name : "Anonymous"
  end

  def favourite_of(user)
    favourites.find_by_user_id(user.id) if user
  end

  private

  def self.search(search_term)
      where(["title ILIKE ? OR body ILIKE ?", "%#{search_term}%", "%#{search_term}%"])
  end
end
