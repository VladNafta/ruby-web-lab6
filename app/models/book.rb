# [згенеровано] rails generate scaffold Book (клас і belongs_to :genre)
# [власний код] зв'язки, валідації FR-3.1, пошук FR-4.1, підрахунок вільних примірників FR-3.4
class Book < ApplicationRecord
  belongs_to :genre

  # ---- власний код ----
  PER_PAGE = 20
  SORTS = { "title" => "назвою", "new" => "датою додавання", "rating" => "оцінкою" }.freeze

  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors
  has_many :reservations, dependent: :restrict_with_error
  has_many :reviews, dependent: :destroy
  has_many :shelf_items, dependent: :destroy

  normalizes :isbn, with: ->(v) { v.to_s.delete("- ").strip }

  validates :title, presence: true
  validates :isbn, presence: true, uniqueness: true,
                   format: { with: /\A(\d{10}|\d{13})\z/, message: "має містити 10 або 13 цифр" }
  validates :copies_count, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :year, numericality: { only_integer: true, greater_than: 1450, less_than_or_equal_to: Date.current.year },
                   allow_nil: true
  validates :authors, presence: true

  before_save :build_search_text

  scope :newest, -> { order(created_at: :desc) }
  scope :search, ->(q) { where("books.search_text LIKE ?", "%#{sanitize_sql_like(q.to_s.downcase.strip)}%") }
  # Книги, у яких активних бронювань менше, ніж примірників
  scope :available, -> {
    where("books.copies_count > (SELECT COUNT(*) FROM reservations r " \
          "WHERE r.book_id = books.id AND r.status IN (0, 1))")
  }
  scope :by_rating, -> {
    left_joins(:reviews).group("books.id")
      .order(Arel.sql("AVG(reviews.rating) IS NULL, AVG(reviews.rating) DESC"), :title)
  }

  # Найбільше бронювань за останні 30 днів (блок «Популярне цього місяця»)
  def self.popular(limit = 8)
    joins(:reservations)
      .where(reservations: { created_at: 30.days.ago.. })
      .group("books.id")
      .order(Arel.sql("COUNT(reservations.id) DESC"), :title)
      .limit(limit)
  end

  def available_count
    copies_count - reservations.active.count
  end

  def available?
    available_count.positive?
  end

  def average_rating
    reviews.average(:rating)&.round(1)
  end

  def author_names
    authors.map(&:name).join(", ")
  end

  private

  def build_search_text
    # String#downcase у Ruby коректно працює з кирилицею, на відміну від LOWER() у SQLite
    self.search_text = [ title, author_names, isbn ].join(" ").downcase
  end
end
