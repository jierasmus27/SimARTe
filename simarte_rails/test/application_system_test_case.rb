# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # Selenium talks to a separate Puma thread; transactional tests can hide fixture data from the server.
  self.use_transactional_tests = false

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 900] do |options|
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1400,900")
    options.binary = ENV["CHROME_BIN"] if ENV["CHROME_BIN"].present?
  end

  private

  def sign_in_admin_via_ui
    visit root_path
    fill_in "Registry ID", with: users(:one).email
    fill_in "Encryption Key", with: "password123"
    click_button "INITIALIZE SESSION"
    assert_text "User Management"
  end
end
