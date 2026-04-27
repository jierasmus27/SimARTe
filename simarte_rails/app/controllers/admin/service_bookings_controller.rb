class Admin::ServiceBookingsController < Admin::BaseController
  before_action :set_user, only: :create

  def index
    @users = policy_scope(User).order(:email)
    @selected_user_id = params[:user_id].presence
    @selected_date = params[:date].presence
    @service_booking_time_slots = policy_scope(ServiceBookingTimeSlot).where('DATE(start_time) = :start_date', start_date: start_date)
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
    flash[:error] = 'No open bookings, please try another slot'
  end

  private

  def service_booking_params
    params.require(:service_booking).permit(:user_id, :service_booking_time_slot_id)
  end

  def set_user
    @user = User.find(service_booking_params[:user_id])
  end

  def start_date
    params[:date].present? ? Time.zone.parse(params[:date]) : Time.current
  end
end
