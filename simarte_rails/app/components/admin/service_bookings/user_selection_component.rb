# frozen_string_literal: true

class Admin::ServiceBookings::UserSelectionComponent < ViewComponent::Base
  def initialize(users:, selected_user_id: nil, field_name: :user_id, form_id: nil)
    @users = users
    @selected_user_id = selected_user_id.to_s.presence
    @field_name = field_name
    @form_id = form_id
  end

  private

  attr_reader :users, :selected_user_id, :field_name, :form_id

  def selected_user
    @selected_user ||= users.find { |user| user.id.to_s == selected_user_id }
  end

  def selected_label
    return "Select client user" unless selected_user

    "#{selected_user.full_name} · #{selected_user.email}"
  end
end
