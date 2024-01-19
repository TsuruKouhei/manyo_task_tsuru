class Task < ApplicationRecord
  validates :title, presence: { message: :blank }
  validates :content, presence: { message: :blank }
end
