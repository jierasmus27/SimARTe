class ServiceBooking < ApplicationRecord
  belongs_to :user
  belongs_to :service_booking_time_slot, counter_cache: true

  # validate :no_overlapping_booking

end
