# [власний код] щоденне скасування неотриманих бронювань (FR-4.3); розклад — config/recurring.yml
class ExpireReservationsJob < ApplicationJob
  queue_as :default

  def perform
    Reservation.expire_overdue!
  end
end
