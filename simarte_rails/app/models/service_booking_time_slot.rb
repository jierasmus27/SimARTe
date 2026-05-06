class ServiceBookingTimeSlot < ApplicationRecord
  has_many :service_bookings
  belongs_to :service

  validates :start_time, :end_time, :quantity, presence: true
  validates :end_time, comparison: { greater_than: :start_time }
  validates :quantity, numericality: true
end
