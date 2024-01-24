class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false, message: 'はすでに使用されています' },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: 'の形式が不正です' }
  validates :password, length: { minimum: 6, message: 'は6文字以上で入力してください' }

  before_validation { email.downcase! }

  has_many :tasks, dependent: :destroy

  before_destroy :ensure_at_least_one_admin_remains
  before_update :ensure_at_least_one_admin_remains
  
  private
  
  def ensure_at_least_one_admin_remains
    if User.where(admin: true).count == 1 && self.admin?
      errors.add(:base, '管理者が0人になるため削除できません')
      throw(:abort)
    end
  end
end
