# frozen_string_literal: true

class Admin::ServiceBookings::AvailabilitySlotsComponent < ViewComponent::Base
  def initialize(slots:, selected_date: nil, field_name: :availability_slot)
    @slots = slots
    @selected_date = selected_date
    @field_name = field_name
  end

  private

  attr_reader :slots, :selected_date, :field_name

  def slot_label(slot)
    return slot if slot.is_a?(String)
    return slot[:label] if slot.respond_to?(:[]) && slot[:label].present?

    start_time = slot.respond_to?(:[]) ? slot[:start_time] : nil
    end_time = slot.respond_to?(:[]) ? slot[:end_time] : nil

    [ start_time, end_time ].compact.join(" - ")
  end

  def slot_value(slot)
    return slot if slot.is_a?(String)
    return slot[:value] if slot.respond_to?(:[]) && slot[:value].present?

    slot_label(slot)
  end

  def selected_date_label
    selected_date.presence || "No date selected"
  end
end
