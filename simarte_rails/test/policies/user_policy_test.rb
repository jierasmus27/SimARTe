# frozen_string_literal: true

require "test_helper"

class UserPolicyTest < ActiveSupport::TestCase
  setup do
    @admin = users(:one)
    @regular = users(:two)
  end

  test "index? allows admins only" do
    assert_predicate UserPolicy.new(@admin, User), :index?
    assert_not UserPolicy.new(@regular, User).index?
  end

  test "update? allows admin to change a non-admin user" do
    assert_predicate UserPolicy.new(@admin, @regular), :update?
  end

  test "update? allows admin to change another admin" do
    @regular.update!(role: :admin)

    assert_predicate UserPolicy.new(@admin, @regular), :update?
  end

  test "update? allows admin to keep or set own role to admin" do
    @admin.assign_attributes(role: :admin)

    assert_predicate UserPolicy.new(@admin, @admin), :update?
  end

  test "update? denies admin demoting self from admin to user" do
    @admin.assign_attributes(role: :user)

    assert_not UserPolicy.new(@admin, @admin).update?
  end

  test "update? denies non-admins" do
    assert_not UserPolicy.new(@regular, @admin).update?
    assert_not UserPolicy.new(@regular, @regular).update?
  end

  test "Scope resolves all users for admins and none for others" do
    admin_scope = UserPolicy::Scope.new(@admin, User.all).resolve
    assert_equal User.count, admin_scope.count

    other_scope = UserPolicy::Scope.new(@regular, User.all).resolve
    assert_empty other_scope
  end
end
