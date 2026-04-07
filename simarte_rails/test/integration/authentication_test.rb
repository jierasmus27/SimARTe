require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "signed-in user visiting root is redirected to admin" do
    sign_in users(:one)

    get root_path
    assert_redirected_to admin_users_path
  end
end
