# frozen_string_literal: true

require "test_helper"

class SidekiqWebTest < ActionDispatch::IntegrationTest
  test "guest is redirected away from sidekiq" do
    get "/sidekiq"

    assert_response :redirect
    assert_match %r{/users/sign_in\z}, @response.headers["Location"]
  end

  test "signed-in non-admin cannot access sidekiq" do
    sign_in users(:two)

    get "/sidekiq"

    assert_response :not_found
  end

  test "admin can access sidekiq" do
    sign_in users(:one)

    get "/sidekiq"

    assert_response :success
    assert_includes @response.body, "Sidekiq"
  end
end
