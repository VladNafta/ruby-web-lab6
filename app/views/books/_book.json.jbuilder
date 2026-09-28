json.extract! book, :id, :title, :isbn, :year, :description, :copies_count, :genre_id, :created_at, :updated_at
json.url book_url(book, format: :json)
