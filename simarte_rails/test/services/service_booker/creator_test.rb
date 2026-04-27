
require "test_helper"

class ServiceBooker::CreatorTest < ActiveSupport::TestCase
  test "#create" do
    user = users(:two)
    service_booking_time_slot = service_booking_time_slots(:early_slot)

    ServiceBookingTimeSlot.reset_counters(service_booking_time_slot.id, :service_bookings)
    service_booking_time_slot.reload

    refute_predicate ServiceBooking.where(user:, service_booking_time_slot:), :exists?

    first_service_booking_count = service_booking_time_slot.service_bookings.size

    assert service_booking_time_slot.quantity > first_service_booking_count

    service_booking = nil

    assert_difference 'ServiceBooking.count', +1 do
      service_booking = ServiceBooker::Creator.new(user:, service_booking_time_slot:).create
    end

    assert_predicate service_booking, :present?
    assert_equal first_service_booking_count + 1, service_booking_time_slot.reload.service_bookings_count
  end

  test "#create raises BookedOutError if service is booked out" do
    user = users(:two)
    service_booking_time_slot = service_booking_time_slots(:early_slot)
    service_booking_time_slot.update!(quantity: 1)

    ServiceBookingTimeSlot.reset_counters(service_booking_time_slot.id, :service_bookings)
    service_booking_time_slot.reload

    refute_predicate ServiceBooking.where(user:, service_booking_time_slot:), :exists?

    first_service_booking_count = service_booking_time_slot.service_bookings.size

    assert_equal service_booking_time_slot.quantity, first_service_booking_count

    assert_difference 'ServiceBooking.count', 0 do
      assert_raises ServiceBooker::Creator::BookedOutError do
        ServiceBooker::Creator.new(user:, service_booking_time_slot:).create
      end
    end
  end
end
