require "test_helper"

class ServiceBookingTimeSlotTest < ActiveSupport::TestCase
  test "#presence" do
    time_slot = service_booking_time_slots(:early_slot)

    assert_predicate time_slot, :valid?

    time_slot.start_time = nil

    refute_predicate time_slot, :valid?

    assert_includes time_slot.errors.full_messages, "Start time can't be blank"
  end

  test "#comparison" do
    time_slot = service_booking_time_slots(:early_slot)

    assert time_slot.start_time < time_slot.end_time
    assert_predicate time_slot, :valid?

    time_slot.end_time = time_slot.start_time - 1.minute
    refute_predicate time_slot, :valid?

    assert_includes time_slot.errors.full_messages, "End time must be greater than 2026-04-27 11:00:00 UTC"
  end
end
