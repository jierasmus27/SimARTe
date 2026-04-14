# frozen_string_literal: true

require "application_system_test_case"

class AdminUserRolesTest < ApplicationSystemTestCase
  test "admin changes a user role via the select modal and back" do
    sign_in_admin_via_ui

    jane = users(:two)
    assert_equal "user", jane.role

    # Promote to admin (scope to this row so we target the correct modal on a busy table)
    jane_row = find("tr[data-user-id='#{jane.id}']")
    jane_row.find("[data-action*='modal-dialog#open']").click
    jane_row.find("[data-option-value='admin']").click

    # Role badge uses CSS uppercase; Capybara retries until redirect + re-render.
    within find("tr[data-user-id='#{jane.id}'] td:nth-child(2)", wait: 10) do
      assert_text "ADMIN"
    end

    # Demote back to user (same page; unique hidden field ids per row avoid wrong input updates)
    jane_row = find("tr[data-user-id='#{jane.id}']")
    jane_row.find("[data-action*='modal-dialog#open']").click
    jane_row.find("[data-option-value='user']").click

    within find("tr[data-user-id='#{jane.id}'] td:nth-child(2)", wait: 10) do
      assert_text "USER"
    end
  end
end
