class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :category_id
      t.string :floor
      t.attachment :room_pic

      t.timestamps null: false
    end
  end
end

