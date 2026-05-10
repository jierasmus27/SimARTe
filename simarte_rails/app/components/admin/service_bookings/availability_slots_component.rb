# frozen_string_literal: true

class Admin::ServiceBookings::AvailabilitySlotsComponent < ViewComponent::Base
  def initialize(selected_user_id:, service_booking_time_slots:, selected_date: nil, form_id: "service_booking_form", field_name: "service_booking[service_booking_time_slot_id]")
    @selected_user_id = selected_user_id
    @service_booking_time_slots = service_booking_time_slots
    @selected_date = selected_date
    @form_id = form_id
    @field_name = field_name
  end

  private

  attr_reader :selected_user_id, :service_booking_time_slots, :selected_date, :form_id, :field_name

  def slot_label(slot)
    return slot_time_label(slot) unless slot.label.present?

    [ slot_time_label(slot), " ", "[", slot.label, "]" ].compact.join
  end

  def slot_time_label(slot)
    start_time = slot.start_time.strftime("%H:%M")
    end_time = slot.end_time.strftime("%H:%M")

    [ start_time, " - ", end_time ].compact.join
  end

  def slot_value(slot)
    slot.id
  end

  def selected_date_label
    selected_date.presence || "No date selected"
  end
end
