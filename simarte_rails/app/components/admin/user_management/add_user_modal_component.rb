# frozen_string_literal: true

class Admin::UserManagement::AddUserModalComponent < ViewComponent::Base
  def initialize(user:, search_query: nil, page: nil)
    @user = user
    @search_query = search_query.presence
    @page = page.presence
  end

  private

  attr_reader :user, :search_query, :page

  def form_id
    "add_user_form"
  end
end
