class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false, message: 'はすでに使用されています' },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: 'の形式が不正です' }
  validates :password, length: { minimum: 6, message: 'は6文字以上で入力してください' }

  before_validation { email.downcase! }

  has_many :tasks, dependent: :destroy

  # before_destroy :ensure_at_least_one_admin_remains
  # validate :ensure_at_least_one_admin_remains_on_update, on: :update
  before_destroy :ensure_at_least_one_admin_remains
  before_update :ensure_at_least_one_admin_remains_on_update
  
  private
  def ensure_at_least_one_admin_remains
    if admin?
      if User.where(admin: true).count <= 1
        errors.add(:base, "管理者が0人になるため削除できません")
        throw(:abort)
      end
    end
  end

  def ensure_at_least_one_admin_remains_on_update
    if admin_changed? && admin == false && User.where(admin: true).count <= 1
      errors.add(:base, "管理者が0人になるため権限を変更できません")
      throw(:abort)
    end
  end

end

