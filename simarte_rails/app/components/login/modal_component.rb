# frozen_string_literal: true

class Login::ModalComponent < ViewComponent::Base
  def initialize(title: "SimARTe Admin Login", alert: nil)
    @title = title
    @alert = alert
  end

  def alert_message
    @alert.presence || helpers.flash[:alert]
  end

  private

  attr_reader :title
end
