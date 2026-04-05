# frozen_string_literal: true

class Login::PageComponent < ViewComponent::Base
  def initialize(alert: nil)
    @alert = alert
  end

  attr_reader :alert
end
