module ServiceBooker
  class Creator
    class BookedOutError < StandardError; end

    def initialize(user:, service_booking_time_slot:)
      @user = user
      @service_booking_time_slot = service_booking_time_slot
    end

    def create
      service_booking_time_slot.with_lock do
        existing = ServiceBooking.find_by(
          user:,
          service_booking_time_slot:
        )

        return existing if existing

        raise BookedOutError if service_booking_time_slot.quantity <= service_booking_time_slot.service_bookings.size

        ServiceBooking.create!(
          user:,
          service_booking_time_slot:
        )
      end
    rescue ActiveRecord::RecordNotUnique
      # Deal with this still
    end

    private

    attr_reader :user, :service_booking_time_slot
  end
end
