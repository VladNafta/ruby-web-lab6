# [згенеровано] rails generate scaffold Author
# [власний код] зв'язок «багато до багатьох» з книгами через book_authors
class Author < ApplicationRecord
  has_many :book_authors, dependent: :restrict_with_error
  has_many :books, through: :book_authors

  validates :name, presence: true

  # Після перейменування автора оновлюємо пошуковий рядок його книг
  after_update_commit { books.each(&:save) if saved_change_to_name? }

  scope :ordered, -> { order(:name) }
end
