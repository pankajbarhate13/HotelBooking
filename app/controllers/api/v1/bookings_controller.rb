class Api::V1::BookingsController < Api::V1::BaseController
  # before_filter :restrict_access
  # skip_before_filter  :verify_authenticity_token
  
  # API which shows availability of room by passing booking date and or room type
  def availability
    if params[:room_type].present? || params[:start_date].present? || params[:end_date].present?
      
      @bookings = Booking.all
      @cat = Category.all
      category_id = Category.find_by_name(params[:room_type]).id if params[:room_type].present?
      if @bookings.present?
        if @bookings
          ids = @bookings.pluck(:room_id)
          date1 = params[:start_date].to_date if params[:start_date].present?
          @start_date = date1.strftime("%Y %d %m") if date1.present?
          date2 = params[:end_date].to_date if params[:end_date].present?
          @end_date = date2.strftime("%Y %d %m") if date2.present?

          if category_id.present? and params[:start_date].present? and params[:end_date].present?

            bookings = Booking.where("category_id = ? and start_date <= ? OR end_date >= ?", category_id, @start_date,@end_date).pluck(:room_id)

            @rooms = Room.where("category_id = ?  and id NOT IN (?) ",category_id,bookings)
            if @rooms.present?
              render json: {message: "Available!", rooms: @rooms,  status: 200}
            else
              render json: {message: "No Rooms found", status: 406}
            end

          elsif category_id.present? and params[:start_date].present? 
            
            bookings = Booking.where("category_id = ? or start_date = ? ", category_id, @start_date).pluck(:room_id)
            @rooms = Room.where("category_id = ?  and id NOT IN (?) ",category_id,bookings)
            if @rooms.present?
            render json: {message: "Available!", rooms: @rooms,  status: 200}
            else
              render json: {message: "No Rooms found", status: 406}
            end

          elsif category_id.present? and params[:end_date].present? 
            
            bookings = Booking.where("category_id = ? or end_date = ? ", category_id, @end_date).pluck(:room_id)
            @rooms = Room.where("category_id = ?  and id NOT IN (?) ",category_id,bookings)
            if @rooms.present?
            render json: {message: "Available!", rooms: @rooms,  status: 200} 
            else
              render json: {message: "No Rooms found", status: 406}
            end

          elsif category_id.present? 
            @rooms = Room.where(category_id: category_id)
            if @rooms.present?
            render json: {message: "Available!", rooms: @rooms,  status: 200}
            else
              render json: {message: "No Rooms found", status: 406}
            end
          
          elsif params[:start_date].present?
             # redirect_to request.referer, notice: 'Please Select End Date'
             render json: {message: "Please Select End Date",  status: 404}
          elsif params[:end_date].present?
              # redirect_to request.referer, notice: 'Please Select Start Date'
              render json: {message: "Please Select Start Date", status: 404}
          else
            render json: {message: "Please Select Date", status: 404}
          end
        end
      else
        category = Category.find(category_id)
        @rooms = category.rooms
        if @rooms.present?
          render json: {message: "Available!", rooms: @rooms,  status: 200}
        else
              render json: {message: "No Rooms found", status: 406}
        end
      end
    else
      render json: {message: "Invalid call. Missing parameters.", status: 406}
    end
  end

  # API shows booked room and booking information
  def book_info
    if params[:user_id].present?
      @booking_info = Booking.where("user_id = ?",params[:user_id])
      @rooms = Room.where("id IN (?)", @booking_info.pluck(:room_id))
      if @booking_info.present? and @rooms.present?
        render :book_info 
      else
        render json: {message: "No Bookings found", status: 406}
      end
    else
      render json: {message: "Invalid call. Missing parameters.", status: 406}
    end
  end

  # private

  # def restrict_access
  #   api_key = User.find_by_secrete_key(params[:secrete_key])
  #   render json: { data: "Unauthorised", status: 401 } unless api_key
  # end

end
