# [згенеровано] rails g model Reservation (belongs_to :user, :book)
# [власний код] статуси та правила бронювання FR-4.2–FR-4.4
class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :book

  # ---- власний код ----
  HOLD_DAYS = 3
  LOAN_DAYS = 14
  MAX_ACTIVE = 5
  STATUS_NAMES = { "reserved" => "Заброньовано", "issued" => "Видано",
                   "returned" => "Повернено", "cancelled" => "Скасовано" }.freeze

  # enum динамічно додає методи reserved?, issued!, scope Reservation.issued тощо
  enum :status, { reserved: 0, issued: 1, returned: 2, cancelled: 3 }

  scope :active, -> { where(status: [ :reserved, :issued ]) }
  scope :recent, -> { order(created_at: :desc) }

  validate :book_must_be_available, on: :create
  validate :user_limit_not_exceeded, on: :create

  before_create { self.expires_at = HOLD_DAYS.days.from_now }

  def status_name
    STATUS_NAMES[status]
  end

  def issue!
    update!(status: :issued, due_on: LOAN_DAYS.days.from_now.to_date)
  end

  def return!
    update!(status: :returned)
  end

  # Неотримані вчасно бронювання скасовуються (FR-4.3); викликається з ExpireReservationsJob
  def self.expire_overdue!
    reserved.where(expires_at: ...Time.current).update_all(status: statuses[:cancelled], updated_at: Time.current)
  end

  private

  def book_must_be_available
    errors.add(:base, "Немає вільних примірників цієї книги") if book && !book.available?
  end

  def user_limit_not_exceeded
    return unless user && user.reservations.active.count >= MAX_ACTIVE

    errors.add(:base, "Не можна мати більше #{MAX_ACTIVE} активних бронювань і видач")
  end
end
