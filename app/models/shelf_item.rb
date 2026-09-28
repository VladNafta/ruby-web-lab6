# [згенеровано] rails g model ShelfItem (belongs_to :user, :book)
# [власний код] полиці читача FR-4.6
class ShelfItem < ApplicationRecord
  belongs_to :user
  belongs_to :book

  SHELF_NAMES = { "want" => "Хочу прочитати", "reading" => "Читаю", "read" => "Прочитано" }.freeze

  enum :shelf, { want: 0, reading: 1, read: 2 }

  validates :book_id, uniqueness: { scope: :user_id }

  def shelf_name
    SHELF_NAMES[shelf]
  end
end
