# frozen_string_literal: true

class Admin::TopBarComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  private

  attr_reader :user
end
