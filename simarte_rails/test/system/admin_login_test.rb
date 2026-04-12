# frozen_string_literal: true

require "application_system_test_case"

class AdminLoginTest < ApplicationSystemTestCase
  test "admin signs in from root and lands on user management" do
    visit root_path

    fill_in "Registry ID", with: users(:one).email
    fill_in "Encryption Key", with: "password123"
    click_button "INITIALIZE SESSION"

    assert_text "User Management"
    assert_current_path admin_users_path
  end
end
