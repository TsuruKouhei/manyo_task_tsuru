class Task < ApplicationRecord
  validates :title, presence: { message: :blank }
  validates :content, presence: { message: :blank }
  validates :deadline_on, presence: { message: :blank }
  validates :priority, presence: { message: :blank }
  validates :status, presence: { message: :blank }
  enum priority: { "低": 0, "中": 1, "高": 2 }
  enum status: { "未着手": 0, "着手中": 1, "完了": 2 }
  # タイトルによる検索
  scope :search_by_title, -> (title) { where("title LIKE ?", "%#{title}%") if title.present? }

  # ステータスによる検索
  scope :search_by_status, -> (status) { where(status: status) if status.present? }

  # 期限日でソート
  scope :sort_by_deadline, -> { order(deadline_on: :asc, created_at: :desc) }

  # 優先度でソート
  scope :sort_by_priority, -> { order(priority: :desc, created_at: :desc) }
end