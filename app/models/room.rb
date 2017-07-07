class Room < ActiveRecord::Base
  has_attached_file :room_pic, styles: { small: "64x64", med: "100x100", large: "200x200" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :room_pic, content_type: /\Aimage\/.*\z/
  has_many :bookings
  belongs_to :category
end
