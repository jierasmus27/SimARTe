# frozen_string_literal: true

require "test_helper"

class Admin::UsersTest < ActionDispatch::IntegrationTest
  def put_user_role(user, role, format: :turbo_stream)
    put admin_user_path(user, format: format), params: { user: { role: role } }
  end

  def assert_replaces_user_table_row(target)
    assert_response :success
    assert_includes response.media_type, "turbo-stream"
    assert_match(/<turbo-stream/, response.body)
    assert_match(/action="replace"/, response.body)
    assert_match(
      /#{Regexp.escape(ActionView::RecordIdentifier.dom_id(target, :table_row))}/,
      response.body
    )
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

    assert_replaces_user_table_row(target)
    assert_predicate target.reload, :admin?
  end

  test "admin can change role back to user" do
    target = users(:two)
    target.update!(role: :admin)
    sign_in users(:one)

    put_user_role(target, "user")

    assert_replaces_user_table_row(target)
    assert_predicate target.reload, :user?
  end
end
