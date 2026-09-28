# [згенеровано] rails generate scaffold Book title:string isbn:string:uniq year:integer
#               description:text copies_count:integer genre:references
# [власний код] обмеження NOT NULL, типова кількість примірників, поле search_text для пошуку
class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :isbn, null: false
      t.integer :year
      t.text :description
      t.integer :copies_count, null: false, default: 1
      t.references :genre, null: false, foreign_key: true
      # [власний код] рядок для пошуку в нижньому регістрі: SQLite LOWER()/LIKE не працюють з кирилицею
      t.text :search_text

      t.timestamps
    end
    add_index :books, :isbn, unique: true
  end
end
