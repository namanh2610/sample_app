class User < ApplicationRecord
  before_save email.downcase!
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: Settings.user_validates.max_lenght_name }
  validates :email, presence: true, length: { maximum: Settings.user_validates.max_lenght_email },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: Settings.users_validates.min_lenght_password }

  has_secure_password
end
