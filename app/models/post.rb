class Post < ActiveRecord::Base

  validates :title, presence: true, uniqueness: { case_insensitive: true }, length: { minimum: 7 }

  validates :body, presence: true

  def body_snippet
    body.length > 100 ? body[0..99].concat("...") : body
  end

  private

  def self.search(search_term)
      where(["title ILIKE ? OR body ILIKE ?", "%#{search_term}%", "%#{search_term}%"])
  end
end
