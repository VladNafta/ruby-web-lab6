# [згенеровано] rails g model Review user:references book:references rating:integer body:text
# [власний код] один відгук від читача на книгу (FR-4.5)
class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :body

      t.timestamps
    end
    add_index :reviews, [ :user_id, :book_id ], unique: true
  end
end
