# [згенеровано] rails generate scaffold Author name:string
# [власний код] null: false для імені
class CreateAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :authors do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
