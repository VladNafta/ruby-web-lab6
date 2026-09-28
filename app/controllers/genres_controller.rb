# [згенеровано] rails generate scaffold Genre
# [власний код] доступ лише для бібліотекаря, українські повідомлення, заборона видалення жанру з книгами
class GenresController < ApplicationController
  before_action :require_staff
  before_action :set_genre, only: %i[ show edit update destroy ]

  # GET /genres
  def index
    @genres = Genre.ordered.left_joins(:books).group(:id).select("genres.*, COUNT(books.id) AS books_count")
  end

  # GET /genres/1
  def show
    redirect_to books_path(genre_id: @genre.id)
  end

  # GET /genres/new
  def new
    @genre = Genre.new
  end

  # GET /genres/1/edit
  def edit
  end

  # POST /genres
  def create
    @genre = Genre.new(genre_params)

    if @genre.save
      redirect_to genres_path, notice: "Жанр «#{@genre.name}» додано."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /genres/1
  def update
    if @genre.update(genre_params)
      redirect_to genres_path, notice: "Жанр перейменовано.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /genres/1
  def destroy
    if @genre.destroy
      redirect_to genres_path, notice: "Жанр видалено.", status: :see_other
    else
      redirect_to genres_path, alert: "Жанр не можна видалити: у ньому є книги.", status: :see_other
    end
  end

  private
    def set_genre
      @genre = Genre.find(params.expect(:id))
    end

    def genre_params
      params.expect(genre: [ :name ])
    end
end
