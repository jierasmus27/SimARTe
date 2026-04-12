# frozen_string_literal: true

require "test_helper"

class Admin::UsersTest < ActionDispatch::IntegrationTest
  # Request HTML explicitly so we assert redirect + flash (Turbo sends turbo_stream by default).
  def put_user_role(user, role)
    put admin_user_path(user, format: :html), params: { user: { role: role } }
  end

  test "guest cannot update user role" do
    target = users(:two)

    put_user_role(target, "admin")

    assert_redirected_to root_path
    assert_equal "user", target.reload.role
  end

  test "signed-in non-admin cannot update user role" do
    target = users(:two)
    sign_in users(:two)

    put_user_role(target, "admin")

    assert_redirected_to root_path
    assert_equal "user", target.reload.role
  end

  test "admin can update user role" do
    target = users(:two)
    sign_in users(:one)

    put_user_role(target, "admin")

    assert_redirected_to admin_users_path
    assert_equal "User updated successfully", flash[:notice]
    assert_predicate target.reload, :admin?
  end

  test "admin can change role back to user" do
    target = users(:two)
    target.update!(role: :admin)
    sign_in users(:one)

    put_user_role(target, "user")

    assert_redirected_to admin_users_path
    assert_predicate target.reload, :user?
  end

  test "admin update returns turbo stream replacing table row" do
    target = users(:two)
    sign_in users(:one)

    put admin_user_path(target, format: :turbo_stream),
      params: { user: { role: "admin" } }

    assert_response :success
    assert_includes response.media_type, "turbo-stream"
    assert_match(/turbo-stream/, response.body)
    assert_match(/action="replace"/, response.body)
    assert_match(/#{Regexp.escape(ActionView::RecordIdentifier.dom_id(target, :table_row))}/, response.body)
    assert_predicate target.reload, :admin?
  end
end
