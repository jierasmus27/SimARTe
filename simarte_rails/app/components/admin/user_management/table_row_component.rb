# frozen_string_literal: true

class Admin::UserManagement::TableRowComponent < ViewComponent::Base
  def initialize(user:, services:)
    @user = user
    @services = services
  end

  private

  attr_reader :user, :services

  def subscribed?(service_id)
    subscriptions_by_service_id.key?(service_id)
  end

  def subscription_for(service)
    subscriptions_by_service_id[service.id]
  end

  def subscriptions_by_service_id
    @subscriptions_by_service_id ||= user.subscriptions.index_by(&:service_id)
  end
end
