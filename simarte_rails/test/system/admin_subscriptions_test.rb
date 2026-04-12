# frozen_string_literal: true

require "application_system_test_case"

class AdminSubscriptionsTest < ApplicationSystemTestCase
  test "admin enables and disables a service subscription from the table" do
    sign_in_admin_via_ui
    visit admin_users_path

    user = users(:one)
    service = services(:gis)
    checkbox_id = "subscription_#{user.id}_service_#{service.id}"

    assert_not Subscription.exists?(user: user, service: service)

    toggle_cell = find("tr[data-user-id='#{user.id}'] td[data-service-id='#{service.id}']")
    toggle_cell.find("label").click

    within find("tr[data-user-id='#{user.id}'] td[data-service-id='#{service.id}']", wait: 10) do
      assert_field checkbox_id, checked: true, visible: :all
    end

    toggle_cell = find("tr[data-user-id='#{user.id}'] td[data-service-id='#{service.id}']")
    toggle_cell.find("label").click

    within find("tr[data-user-id='#{user.id}'] td[data-service-id='#{service.id}']", wait: 10) do
      assert_field checkbox_id, checked: false, visible: :all
    end

    assert_not Subscription.exists?(user: user, service: service)
  end
end
