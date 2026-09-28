# [згенеровано] rails generate scaffold Genre
# [власний код] зв'язок з книгами і валідації
class Genre < ApplicationRecord
  has_many :books, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }
end
