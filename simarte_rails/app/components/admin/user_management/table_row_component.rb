# frozen_string_literal: true

class Admin::UserManagement::TableRowComponent < ViewComponent::Base
  def initialize(user:, services:)
    @user = user
    @services = services
  end

  private

  attr_reader :user, :services

  def subscribed?(service_id)
    subscribed_service_ids.include?(service_id)
  end

  def subscribed_service_ids
    @subscribed_service_ids ||= user.services.ids.to_set
  end
end
