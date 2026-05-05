# frozen_string_literal: true

class Admin::ServiceBookings::DatePickerComponent < ViewComponent::Base
  def initialize(selected_date: Date.current, field_name: :date)
    @selected_date = selected_date
    @field_name = field_name
  end

  private

  attr_reader :selected_date, :field_name

  def current_month
    @current_month ||= selected_date.month
  end

  def current_year
    @current_year ||= selected_date.year
  end

  def days_from_last_month
    @days_from_last_month ||= (
      selected_date.beginning_of_month.to_date -
        (selected_date.beginning_of_month.wday + 1).days
    )..selected_date.last_month.end_of_month
  end

  def unselectable_start_days_of_month
    return [] unless selected_date.beginning_of_month == Time.current.beginning_of_month
    return [] if Time.current.day == 1

    @unselectable_start_days_of_month ||= selected_date.beginning_of_month.to_date..(Time.current.to_date - 1.day)
  end

  def unselectable_start_days
    @unselectable_start_days ||= days_from_last_month.to_a + unselectable_start_days_of_month.to_a
  end

  def selectable_days_of_month
    (selected_date.beginning_of_month..selected_date.end_of_month).to_a - unselectable_start_days
  end

end
