class PasswordReset
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::SecurePassword

  attr_accessor :password_digest

  has_secure_password
end
