class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password_digest, presence: true, length: { minimum: 6 }, uniqueness: true
  before_validation { email.downcase! }
  validates :password, presence: true, length: { minimum: 6 }
  has_many :tasks, dependent: :destroy
end
