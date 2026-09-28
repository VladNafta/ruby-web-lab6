# [власний код] обробка бронювань і видач бібліотекарем (FR-3.5)
module Library
  class ReservationsController < ApplicationController
    before_action :require_staff
    before_action :set_reservation, only: %i[ issue return_book ]

    def index
      @status = params[:status].presence_in(Reservation.statuses.keys)
      @counts = Reservation.group(:status).count
      @reservations = Reservation.includes(:user, book: :authors).recent
      @reservations = @reservations.where(status: @status) if @status
    end

    def issue
      if @reservation.reserved?
        @reservation.issue!
        flash[:notice] = "Книгу «#{@reservation.book.title}» видано читачу #{@reservation.user.name} до #{I18n.l(@reservation.due_on)}."
      end
      redirect_to library_reservations_path(status: params[:status]), status: :see_other
    end

    def return_book
      if @reservation.issued?
        @reservation.return!
        flash[:notice] = "Книгу «#{@reservation.book.title}» повернено."
      end
      redirect_to library_reservations_path(status: params[:status]), status: :see_other
    end

    private

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end
  end
end
