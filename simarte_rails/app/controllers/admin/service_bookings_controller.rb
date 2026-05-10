class Admin::ServiceBookingsController < Admin::BaseController
  before_action :set_user, only: :create

  def index
    load_service_bookings_index

    if turbo_frame_request? && turbo_frame_request_id == "service_booking_date_picker"
      render :date_picker_frame, layout: false
    end
  end

  def create
    authorize @user

    service_booking_time_slot = ServiceBookingTimeSlot.find(service_booking_params[:service_booking_time_slot_id])

    service_booker = ServiceBooker::Creator.new(
      user: @user,
      service_booking_time_slot: service_booking_time_slot
    )

    @service_booking = service_booker.create
  rescue ServiceBooker::Creator::BookedOutError
    flash[:error] = "No open bookings, please try another slot"
  end

  private

  def load_service_bookings_index
    @users = policy_scope(User).order(:email)
    @selected_user_id = params[:user_id].presence
    bookings = policy_scope(ServiceBooking)
    bookings = bookings.where(user_id: @selected_user_id) if @selected_user_id.present?
    @service_bookings = bookings.order(created_at: :desc)
    @selected_date = selected_date
    @service_booking_time_slots = policy_scope(ServiceBookingTimeSlot)
      .includes(:service_bookings)
      .where(start_time: @selected_date.all_day)
      .order(:start_time)
  end

  def service_booking_params
    params.require(:service_booking).permit(:user_id, :service_booking_time_slot_id)
  end

  def set_user
    @user = User.find(service_booking_params[:user_id])
  end

  def selected_date
    return Time.zone.today if params[:date].blank?

    Date.parse(params[:date])
  rescue Date::Error
    Time.zone.today
  end
end
