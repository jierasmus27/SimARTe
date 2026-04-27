class Admin::ServiceBookingTimeSlotsController < ApplicationController
  def index
    @service_booking_time_slots = policy_scope(ServiceBookingTimeSlot).where('DATE(start_time) = :start_date', start_date: start_date)
  end

  private

  def start_date
    Time.zone.parse(params[:date])
  end
end
