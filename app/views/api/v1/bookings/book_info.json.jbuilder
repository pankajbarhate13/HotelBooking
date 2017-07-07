json.booking_info @booking_info
if @booking_info
  json.booking_info @booking_info do |booking_info|
  
  json.booking_start_date booking_info.start_date
  json.booking_end_date  booking_info.end_date
  json.booking_amount  booking_info.amount
  json.username booking_info.full_name
  json.address booking_info.address
  json.phone_no booking_info.phone_no

  json.room_info do
    room = Room.find(booking_info.room_id)
    json.room_no room.floor
    json.room_type room.category.name
    json.room_price room.category.price
    json.room_desc room.category.description
  end
    
  end
  json.status 200

else
  json.status 406
  json.message 'Data Not Found'
end