class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :room_id
      t.integer :category_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :amount
      t.string :full_name
      t.string :address
      t.string :phone_no


      t.timestamps null: false
    end
  end
end
