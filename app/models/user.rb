class User < ActiveRecord::Base
  has_many :posts, dependent: :nullify
  has_many :comments, dependent: :nullify

  has_many :favourites, dependent: :destroy
  has_many :favourite_posts, through: :favourites, source: :posts

  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true

  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX

  # validate :check_old_and_new_password
  #
  # def check_old_and_new_password
  #   errors.add(:new_password, "can't be the same as current password") if :password == :new_password
  # end

  def full_name
    "#{first_name} #{last_name}"
  end

end
