# [згенеровано] rails g controller Home index
# [власний код] блоки «Нові надходження» і «Популярне цього місяця» (SRS, п. 4.1.1)
class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @new_books = Book.newest.includes(:authors, :genre).limit(8)
    @popular_books = Book.popular(8).includes(:authors, :genre).to_a
  end
end
