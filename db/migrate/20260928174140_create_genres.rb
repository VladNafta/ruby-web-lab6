# [згенеровано] rails generate scaffold Genre name:string:uniq
# [власний код] null: false для назви
class CreateGenres < ActiveRecord::Migration[8.1]
  def change
    create_table :genres do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :genres, :name, unique: true
  end
end
