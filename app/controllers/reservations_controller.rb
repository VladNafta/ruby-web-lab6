# [власний код] бронювання книг читачем (FR-4.2, FR-4.3)
class ReservationsController < ApplicationController
  def index
    @reservations = current_user.reservations.includes(book: :authors).recent
  end

  def create
    book = Book.find(params.expect(:book_id))
    reservation = current_user.reservations.new(book: book)

    if reservation.save
      redirect_to book, notice: "Книгу заброньовано. Заберіть її на абонементі до #{I18n.l(reservation.expires_at, format: :short)}."
    else
      redirect_to book, alert: reservation.errors.full_messages.to_sentence
    end
  end

  # Читач може скасувати лише своє ще не видане бронювання
  def destroy
    reservation = current_user.reservations.reserved.find(params[:id])
    reservation.cancelled!
    redirect_to reservations_path, notice: "Бронювання книги «#{reservation.book.title}» скасовано.", status: :see_other
  end
end
