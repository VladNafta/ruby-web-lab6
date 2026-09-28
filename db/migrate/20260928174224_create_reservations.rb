# [згенеровано] rails g model Reservation user:references book:references status:integer
#               expires_at:datetime due_on:date
# [власний код] типовий статус 0 (reserved)
class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.datetime :expires_at
      t.date :due_on

      t.timestamps
    end
  end
end
