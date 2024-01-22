class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false, message: 'はすでに使用されています' },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: 'の形式が不正です' }
  validates :password, length: { minimum: 6, message: 'は6文字以上で入力してください' }

  before_validation { email.downcase! }

  has_many :tasks, dependent: :destroy
end
