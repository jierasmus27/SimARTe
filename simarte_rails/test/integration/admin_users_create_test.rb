# frozen_string_literal: true

require "test_helper"

class AdminUsersCreateTest < ActionDispatch::IntegrationTest
  test "guest cannot create user" do
    assert_no_difference -> { User.count } do
      post admin_users_path, params: valid_user_params, as: :turbo_stream
    end

    assert_redirected_to root_path
  end

  test "non-admin cannot create user" do
    sign_in users(:two)

    assert_no_difference -> { User.count } do
      post admin_users_path, params: valid_user_params, as: :turbo_stream
    end

    assert_redirected_to root_path
  end

  test "admin creates user with turbo stream" do
    sign_in users(:one)

    assert_difference -> { User.count }, 1 do
      post admin_users_path, params: valid_user_params.merge(q: "test"), as: :turbo_stream
    end

    assert_response :success
    assert_includes response.content_type, "turbo-stream"
    new_user = User.find_by!(email: "new.operator@example.com")
    assert_equal "New", new_user.first_name
    assert_equal "Operator", new_user.last_name
    assert new_user.user?
    assert_match(/turbo-stream/, response.body)
    assert_match(/add_user_modal/, response.body)
  end

  test "admin create with invalid data does not persist" do
    sign_in users(:one)

    assert_no_difference -> { User.count } do
      post admin_users_path,
        params: {
          user: {
            email: "",
            first_name: "",
            last_name: "",
            role: "user",
            password: "",
            password_confirmation: ""
          }
        },
        as: :turbo_stream
    end

    assert_response :success
    assert_match(/error/, response.body)
  end

  private

  def valid_user_params
    {
      q: "",
      user: {
        email: "new.operator@example.com",
        first_name: "New",
        last_name: "Operator",
        role: "user",
        password: "password123",
        password_confirmation: "password123"
      }
    }
  end
end
