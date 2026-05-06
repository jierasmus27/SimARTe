# frozen_string_literal: true

class Admin::ServiceBookings::DatePickerComponent < ViewComponent::Base
  def initialize(selected_date: Date.current, field_name: :date)
    @selected_date = selected_date
    @field_name = field_name
  end

  private

  attr_reader :selected_date, :field_name

  def current_month_label
    selected_date.strftime("%B")
  end

  def current_year_label
    "YEAR_#{selected_date.year}"
  end

  def previous_month_date
    selected_date.prev_month.beginning_of_month
  end

  def next_month_date
    selected_date.next_month.beginning_of_month
  end

  def previous_month_selectable?
    previous_month_date >= Time.zone.today.beginning_of_month
  end

  def date_picker_path(date)
    helpers.admin_service_bookings_path(date: date.iso8601)
  end

  def date_link_options(date)
    {
      data: {
        turbo_frame: "service_booking_date_picker"
      },
      class: date_link_class(date),
      aria: { current: ("date" if date == selected_date) }
    }
  end

  def date_link_class(date)
    classes = [
      "flex aspect-square cursor-pointer items-center justify-center text-xs transition-all hover:bg-primary/10"
    ]

    if date == selected_date
      classes << "bg-primary font-bold text-on-primary shadow-[0_0_20px_rgba(172,234,211,0.4)]"
    end

    classes.join(" ")
  end

  def days_from_last_month
    @days_from_last_month ||= begin
      leading_days_count = (selected_date.beginning_of_month.cwday - 1)
      if leading_days_count.zero?
        []
      else
        (selected_date.beginning_of_month - leading_days_count.days)..selected_date.last_month.end_of_month
      end
    end
  end

  def unselectable_start_days_of_month
    return [] unless selected_date.beginning_of_month == Time.zone.today.beginning_of_month
    return [] if Time.zone.today.day == 1

    @unselectable_start_days_of_month ||= selected_date.beginning_of_month..(Time.zone.today - 1.day)
  end

  def unselectable_start_days
    @unselectable_start_days ||= days_from_last_month.to_a + unselectable_start_days_of_month.to_a
  end

  def selectable_days_of_month
    (selected_date.beginning_of_month..selected_date.end_of_month).to_a - unselectable_start_days
  end
end
