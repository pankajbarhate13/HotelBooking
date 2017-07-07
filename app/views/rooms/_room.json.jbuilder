json.extract! room, :id, :category_id, :floor, :room_no, :created_at, :updated_at
json.url room_url(room, format: :json)
