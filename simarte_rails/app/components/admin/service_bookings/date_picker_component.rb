# frozen_string_literal: true

class Admin::ServiceBookings::DatePickerComponent < ViewComponent::Base
  def initialize(selected_date: nil, field_name: :date)
    @selected_date = selected_date
    @field_name = field_name
  end

  private

  attr_reader :selected_date, :field_name
end
