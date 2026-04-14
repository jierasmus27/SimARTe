# frozen_string_literal: true

class Admin::UserManagement::AddUserModalComponent < ViewComponent::Base
  def initialize(user:, search_query: nil)
    @user = user
    @search_query = search_query.presence
  end

  private

  attr_reader :user, :search_query

  def form_id
    "add_user_form"
  end
end
