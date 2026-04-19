# frozen_string_literal: true

require "test_helper"

class JsonSessionsSignInTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
  end

  test "JSON sign-in is not supported; use Auth0 for API tokens" do
    post "/users/sign_in",
      params: {
        user: {
          email: @admin.email,
          password: "password123"
        }
      },
      headers: {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      },
      as: :json

    assert_response :unprocessable_entity
    assert_nil response.headers["Authorization"]
    body = JSON.parse(response.body)
    assert_includes body["error"], "Auth0"
  end
end
