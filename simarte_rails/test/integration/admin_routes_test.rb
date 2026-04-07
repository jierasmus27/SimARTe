require "test_helper"

class AdminRoutesTest < ActionDispatch::IntegrationTest
  test "signed-in user can access admin root" do
    sign_in users(:one)

    get admin_users_path
    assert_response :success
  end

  test "guest is redirected from admin" do
    get admin_users_path
    assert_redirected_to root_path
  end
end
