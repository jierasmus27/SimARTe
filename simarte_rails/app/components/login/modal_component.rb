# frozen_string_literal: true

class Login::ModalComponent < ViewComponent::Base
  def initialize(title: "SimARTe Admin Login")
    @title = title
  end

  private

  attr_reader :title
end
