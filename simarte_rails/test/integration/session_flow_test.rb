require "test_helper"

class SessionFlowTest < ActionDispatch::IntegrationTest
  test "sign in via Devise then sign out" do
    post user_session_path, params: {
      user: { email: users(:one).email, password: "password123" }
    }
    assert_redirected_to admin_root_path

    delete destroy_user_session_path
    assert_response :see_other

    get admin_root_path
    assert_redirected_to root_path
  end
end
