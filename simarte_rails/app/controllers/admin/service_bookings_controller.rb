class Admin::ServiceBookingsController < Admin::BaseController
  def index
    @users = policy_scope(User).order(:email)
    @selected_user_id = params[:user_id].presence
    @selected_date = params[:date].presence
    @availability_slots = []
  end

  def create


  end

  private

  def service_booking_params
    params.require(:service_booking).permit(:user_id, :service_booking_time_slot_id)
  end
end
