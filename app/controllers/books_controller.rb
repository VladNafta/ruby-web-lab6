# [згенеровано] rails generate scaffold Book (дії CRUD, respond_to, set_book, book_params)
# [власний код] пошук і фільтри FR-4.1, пагінація, права доступу, дані для сторінки книги
class BooksController < ApplicationController
  # ---- власний код ----
  allow_unauthenticated_access only: %i[ index show ]
  before_action :require_staff, except: %i[ index show ]
  # ---------------------
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    # ---- власний код ----
    @genre = Genre.find_by(id: params[:genre_id])
    books = Book.includes(:authors, :genre)
    books = books.search(params[:q]) if params[:q].present?
    books = books.where(genre: @genre) if @genre
    books = books.where(year: params[:year]) if params[:year].present?
    books = books.available if params[:available] == "1"
    books = case params[:sort]
            when "new" then books.newest
            when "rating" then books.by_rating
            else books.order(:title)
            end

    @total = books.unscope(:order, :group).distinct.count(:id)
    @pages = [ (@total / Book::PER_PAGE.to_f).ceil, 1 ].max
    @page = params[:page].to_i.clamp(1, @pages)
    @books = books.offset((@page - 1) * Book::PER_PAGE).limit(Book::PER_PAGE)
  end

  # GET /books/1 or /books/1.json
  def show
    # ---- власний код ----
    @reviews = @book.reviews.includes(:user).recent
    @review = Review.new
    if current_user
      @my_review = @reviews.find { |r| r.user_id == current_user.id }
      @my_reservation = current_user.reservations.active.find_by(book: @book)
      @shelf_item = current_user.shelf_items.find_by(book: @book)
    end
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Книгу «#{@book.title}» додано до каталогу." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @book.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Картку книги оновлено.", status: :see_other }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @book.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    # [власний код] книгу з бронюваннями видаляти не можна (FR-3.2)
    if @book.destroy
      redirect_to books_path, notice: "Книгу видалено.", status: :see_other
    else
      redirect_to @book, alert: "Книгу не можна видалити: з нею пов'язані бронювання.", status: :see_other
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def book_params
      # [власний код] додано author_ids: [] для зв'язку «багато до багатьох»
      params.expect(book: [ :title, :isbn, :year, :description, :copies_count, :genre_id, author_ids: [] ])
    end
end
