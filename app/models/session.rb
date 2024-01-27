class Session < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password_digest, presence: true, length: { minimum: 6 }, uniqueness: true
  before_validation { email.downcase! }
  has_secure_password
  validates :password, length: { minimum: 6 }

end
