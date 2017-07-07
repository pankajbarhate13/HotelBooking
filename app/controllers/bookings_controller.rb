class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    # @bookings = Booking.all
    @rooms = Room.all
    @cat = Category.all
  end
  
  def show
  end

  def new
    @booking = Booking.new
  end

  def edit
  end

  def create
    @booking = Booking.new(booking_params)
    respond_to do |format|
      if @booking.save
        format.html { redirect_to bookings_path, notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    @bookings = Booking.all
    @cat = Category.all
    if @bookings.present?
      if @bookings
        ids = @bookings.pluck(:room_id)
        date1 = params[:start_date].to_date if params[:start_date].present?
        @start_date = date1.strftime("%Y %d %m") if date1.present?
        date2 = params[:end_date].to_date if params[:end_date].present?
        @end_date = date2.strftime("%Y %d %m") if date2.present?

        if params[:category_id].present? and params[:start_date].present? and params[:end_date].present?
          bookings = Booking.where("category_id = ? and start_date <= ? OR end_date >= ?", params[:category_id], @start_date,@end_date).pluck(:room_id)

          @rooms = Room.where("category_id = ?  and id NOT IN (?) ",params[:category_id],bookings)
        
        elsif params[:category_id].present? and params[:start_date].present? 
          
          bookings = Booking.where("category_id = ? OR start_date = ? ", params[:category_id], @start_date).pluck(:room_id)
          @rooms = Room.where("category_id = ?  and id NOT IN (?) ",params[:category_id],bookings)
        elsif params[:category_id].present? and params[:end_date].present? 
          
          bookings = Booking.where("category_id = ? OR end_date = ? ", params[:category_id], @end_date).pluck(:room_id)
          @rooms = Room.where("category_id = ?  and id NOT IN (?) ",params[:category_id],bookings)
        elsif params[:category_id].present? 
          @rooms = Room.where(category_id: params[:category_id])
        
        elsif params[:start_date].present?
           redirect_to request.referer, notice: 'Please Select End Date'
        elsif params[:end_date].present?
            redirect_to request.referer, notice: 'Please Select Start Date'
        else
          redirect_to request.referer, notice: 'Please Select Category Or Dates'
        end
      end
    else
      category = Category.find(params[:category_id])
      @rooms = category.rooms
    end
  end

  def book
    
  end

  def amount
    room = Room.find(params[:id])
    price = room.category.price
    @amount = price.to_i * params[:days].to_i
    render :json => {amount: @amount}
  end

  private
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def booking_params
      params.require(:booking).permit(:user_id, :room_id, :category_id, :start_date, :end_date, :amount, :full_name, :address, :phone_no)
    end
end
