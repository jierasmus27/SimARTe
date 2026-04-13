# frozen_string_literal: true

require "test_helper"

class Admin::UsersSearchTest < ActionDispatch::IntegrationTest
  test "guest cannot use user search" do
    get admin_users_path(q: "jane")

    assert_redirected_to root_path
  end

  test "admin search by name substring returns matching user only" do
    sign_in users(:one)

    get admin_users_path(q: "Jane")

    assert_response :success
    assert_match(/table_row_user_#{users(:two).id}/, response.body)
    assert_no_match(/table_row_user_#{users(:one).id}/, response.body)
  end

  test "admin search with empty q shows all users" do
    sign_in users(:one)

    get admin_users_path(q: "")

    assert_response :success
    assert_match(/table_row_user_#{users(:two).id}/, response.body)
    assert_match(/table_row_user_#{users(:one).id}/, response.body)
  end

  test "admin search by email" do
    sign_in users(:one)

    get admin_users_path(q: "admin@ex")

    assert_response :success
    assert_match(/table_row_user_#{users(:one).id}/, response.body)
    assert_no_match(/table_row_user_#{users(:two).id}/, response.body)
  end

  test "admin search by role label" do
    sign_in users(:one)

    get admin_users_path(q: "admin")

    assert_response :success
    assert_match(/table_row_user_#{users(:one).id}/, response.body)
    assert_no_match(/table_row_user_#{users(:two).id}/, response.body)
  end

  test "admin search by subscribed service name" do
    Subscription.create!(user: users(:two), service: services(:gis))
    sign_in users(:one)

    get admin_users_path(q: "GIS")

    assert_response :success
    assert_match(/table_row_user_#{users(:two).id}/, response.body)
    assert_no_match(/table_row_user_#{users(:one).id}/, response.body)
  end

  test "admin search with no matches" do
    sign_in users(:one)

    get admin_users_path(q: "zzznomatchzzz")

    assert_response :success
    assert_no_match(/table_row_user_#{users(:one).id}/, response.body)
    assert_no_match(/table_row_user_#{users(:two).id}/, response.body)
  end
end
