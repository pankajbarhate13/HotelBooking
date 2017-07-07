json.extract! booking, :id, :user_id, :room_id, :start_date, :end_date, :amount, :created_at, :updated_at
json.url booking_url(booking, format: :json)
