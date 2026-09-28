# [згенеровано] rails g migration AddNameAndRoleToUsers name:string role:string
# [власний код] типова роль reader і поле blocked (таблиця 9 SRS)
class AddNameAndRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :role, :string, null: false, default: "reader"
    add_column :users, :blocked, :boolean, null: false, default: false
  end
end
