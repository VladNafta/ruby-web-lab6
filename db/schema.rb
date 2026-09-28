# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_28_174240) do
  create_table "authors", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_authors", force: :cascade do |t|
    t.integer "book_id", null: false
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_book_authors_on_author_id"
    t.index ["book_id", "author_id"], name: "index_book_authors_on_book_id_and_author_id", unique: true
    t.index ["book_id"], name: "index_book_authors_on_book_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.string "isbn", null: false
    t.integer "year"
    t.text "description"
    t.integer "copies_count", default: 1, null: false
    t.integer "genre_id", null: false
    t.text "search_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_books_on_genre_id"
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "book_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "expires_at"
    t.date "due_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reservations_on_book_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "book_id", null: false
    t.integer "rating", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reviews_on_book_id"
    t.index ["user_id", "book_id"], name: "index_reviews_on_user_id_and_book_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shelf_items", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "book_id", null: false
    t.integer "shelf", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_shelf_items_on_book_id"
    t.index ["user_id", "book_id"], name: "index_shelf_items_on_user_id_and_book_id", unique: true
    t.index ["user_id"], name: "index_shelf_items_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.string "role", default: "reader", null: false
    t.boolean "blocked", default: false, null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "book_authors", "authors"
  add_foreign_key "book_authors", "books"
  add_foreign_key "books", "genres"
  add_foreign_key "reservations", "books"
  add_foreign_key "reservations", "users"
  add_foreign_key "reviews", "books"
  add_foreign_key "reviews", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "shelf_items", "books"
  add_foreign_key "shelf_items", "users"
end
