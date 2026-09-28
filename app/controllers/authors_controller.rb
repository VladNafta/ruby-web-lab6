# [згенеровано] rails generate scaffold Author
# [власний код] доступ лише для бібліотекаря, українські повідомлення, заборона видалення автора з книгами
class AuthorsController < ApplicationController
  before_action :require_staff
  before_action :set_author, only: %i[ show edit update destroy ]

  # GET /authors
  def index
    @authors = Author.ordered.includes(:books)
  end

  # GET /authors/1
  def show
  end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/1/edit
  def edit
  end

  # POST /authors
  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to authors_path, notice: "Автора «#{@author.name}» додано."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /authors/1
  def update
    if @author.update(author_params)
      redirect_to authors_path, notice: "Дані автора оновлено.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /authors/1
  def destroy
    if @author.destroy
      redirect_to authors_path, notice: "Автора видалено.", status: :see_other
    else
      redirect_to authors_path, alert: "Автора не можна видалити: у каталозі є його книги.", status: :see_other
    end
  end

  private
    def set_author
      @author = Author.find(params.expect(:id))
    end

    def author_params
      params.expect(author: [ :name ])
    end
end
