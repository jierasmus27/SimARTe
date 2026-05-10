# frozen_string_literal: true

require "test_helper"

class Admin::ServiceBookingsTest < ActionDispatch::IntegrationTest
  test "turbo frame request returns only date picker frame without admin layout" do
    sign_in users(:one)

    get admin_service_bookings_path(user_id: users(:two).id),
      headers: { "Turbo-Frame" => "service_booking_date_picker" }

    assert_response :success
    assert_match(/<turbo-frame[^>]*\bid="service_booking_date_picker"/, response.body)
    assert_no_match(/admin_main/, response.body)
    assert_no_match(/SimARTe/, response.body)
  end
end
