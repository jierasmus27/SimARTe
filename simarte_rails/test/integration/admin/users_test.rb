# frozen_string_literal: true

require "test_helper"

class Admin::UsersTest < ActionDispatch::IntegrationTest
  test "guest cannot update user role" do
    target = users(:two)

    put admin_user_path(target), params: { user: { role: "admin" } }

    assert_redirected_to root_path
    assert_equal "user", target.reload.role
  end

  test "signed-in non-admin cannot update user role" do
    target = users(:two)
    sign_in users(:two)

    put admin_user_path(target), params: { user: { role: "admin" } }

    assert_redirected_to root_path
    assert_equal "user", target.reload.role
  end

  test "admin can update user role" do
    target = users(:two)
    sign_in users(:one)

    put admin_user_path(target), params: { user: { role: "admin" } }

    assert_redirected_to admin_users_path
    assert_equal "User updated successfully", flash[:notice]
    assert_predicate target.reload, :admin?
  end

  test "admin can change role back to user" do
    target = users(:two)
    target.update!(role: :admin)
    sign_in users(:one)

    put admin_user_path(target), params: { user: { role: "user" } }

    assert_redirected_to admin_users_path
    assert_predicate target.reload, :user?
  end
end
