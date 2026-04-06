# frozen_string_literal: true

require "test_helper"

class Admin::SubscriptionsTest < ActionDispatch::IntegrationTest
  test "guest cannot create subscription" do
    post admin_subscriptions_path, params: { user_id: users(:one).id, service_id: services(:ar).id }

    assert_redirected_to root_path
  end

  test "guest cannot destroy subscription" do
    subscription = Subscription.create!(user: users(:one), service: services(:ar))

    delete admin_subscription_path(subscription)

    assert_redirected_to root_path
    assert Subscription.exists?(subscription.id)
  end

  test "signed-in user can create subscription" do
    sign_in users(:one)

    assert_difference -> { Subscription.count }, 1 do
      post admin_subscriptions_path, params: { user_id: users(:one).id, service_id: services(:gis).id }
    end

    assert_redirected_to admin_root_path
    assert Subscription.exists?(user: users(:one), service: services(:gis))
  end

  test "signed-in user can destroy subscription" do
    subscription = Subscription.create!(user: users(:one), service: services(:ar))
    sign_in users(:one)

    assert_difference -> { Subscription.count }, -1 do
      delete admin_subscription_path(subscription)
    end

    assert_redirected_to admin_root_path
    assert_not Subscription.exists?(subscription.id)
  end

  test "create with duplicate subscription shows alert" do
    Subscription.create!(user: users(:one), service: services(:ar))
    sign_in users(:one)

    assert_no_difference -> { Subscription.count } do
      post admin_subscriptions_path, params: { user_id: users(:one).id, service_id: services(:ar).id }
    end

    assert_redirected_to admin_root_path
    assert_equal "User has already been taken", flash[:alert]
  end
end
