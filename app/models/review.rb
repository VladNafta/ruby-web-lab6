# [згенеровано] rails g model Review (belongs_to :user, :book)
# [власний код] валідації FR-4.5
class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :rating, inclusion: { in: 1..5, message: "має бути від 1 до 5" }
  validates :body, length: { maximum: 2000 }
  validates :user_id, uniqueness: { scope: :book_id, message: "уже залишив відгук на цю книгу" }

  scope :recent, -> { order(created_at: :desc) }
end
