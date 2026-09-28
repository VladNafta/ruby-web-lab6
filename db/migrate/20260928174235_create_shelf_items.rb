# [згенеровано] rails g model ShelfItem user:references book:references shelf:integer
# [власний код] книга може бути лише на одній полиці користувача (FR-4.6)
class CreateShelfItems < ActiveRecord::Migration[8.1]
  def change
    create_table :shelf_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.integer :shelf, null: false, default: 0

      t.timestamps
    end
    add_index :shelf_items, [ :user_id, :book_id ], unique: true
  end
end
