# [згенеровано] rails generate authentication (has_secure_password, sessions, normalizes)
# [власний код] ролі, зв'язки та валідації за SRS (FR-1.1–FR-1.3, таблиця 9)
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # ---- власний код ----
  ROLES = %w[reader librarian admin].freeze
  ROLE_NAMES = { "reader" => "Читач", "librarian" => "Бібліотекар", "admin" => "Адміністратор" }.freeze

  has_many :reservations, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :shelf_items, dependent: :destroy
  has_many :shelved_books, through: :shelf_items, source: :book

  validates :name, presence: true, length: { in: 2..50 }
  validates :email_address, presence: true,
                            uniqueness: { message: "уже зареєстровано" },
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { in: 8..72 },
                       format: { with: /\A(?=.*[[:alpha:]])(?=.*\d)/, message: "має містити літеру і цифру" },
                       allow_nil: true
  validates :role, inclusion: { in: ROLES }

  # Динамічно створюємо методи reader?, librarian?, admin? — по одному на кожну роль
  ROLES.each do |r|
    define_method("#{r}?") { role == r }
  end

  # Бібліотекар і адміністратор мають доступ до керування каталогом
  def staff?
    librarian? || admin?
  end

  def role_name
    ROLE_NAMES[role]
  end
end
