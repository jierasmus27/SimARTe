require "test_helper"

class LoginFailureTest < ActionDispatch::IntegrationTest
  test "valid non-admin credentials do not sign in" do
    post user_session_path, params: {
      user: { email: users(:two).email, password: "password123" }
    }

    assert_redirected_to root_path
    assert_equal "Incorrect username or password.", flash[:alert]

    get admin_users_path
    assert_redirected_to root_path
  end

  test "after non-admin login attempt, admin can sign in without already authenticated error" do
    post user_session_path, params: {
      user: { email: users(:two).email, password: "password123" }
    }
    assert_redirected_to root_path

    post user_session_path, params: {
      user: { email: users(:one).email, password: "password123" }
    }

    assert_redirected_to admin_users_path
    follow_redirect!
    assert_response :success
  end

  test "failed login redirects to root with alert, not to devise sign in page" do
    post user_session_path, params: {
      user: { email: users(:one).email, password: "wrong-password" }
    }

    assert_redirected_to root_path
    follow_redirect!

    assert_response :success
    assert_match(/Incorrect username or password/i, response.body)
    assert_no_match %r{/users/sign_in}, request.path
  end
end
