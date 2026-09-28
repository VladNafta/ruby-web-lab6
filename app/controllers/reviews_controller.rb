# [власний код] відгуки й оцінки книг (FR-4.5)
class ReviewsController < ApplicationController
  def index
    @reviews = current_user.reviews.includes(book: :authors).recent
  end

  def create
    book = Book.find(params[:book_id])
    review = book.reviews.new(params.expect(review: [ :rating, :body ]))
    review.user = current_user

    if review.save
      redirect_to book, notice: "Дякуємо за відгук!"
    else
      redirect_to book, alert: review.errors.full_messages.to_sentence
    end
  end

  def destroy
    review = current_user.reviews.find(params[:id])
    review.destroy
    redirect_to review.book, notice: "Відгук видалено.", status: :see_other
  end
end
