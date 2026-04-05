require "test_helper"

class LoginFailureTest < ActionDispatch::IntegrationTest
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
