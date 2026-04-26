class CreateServiceBookingTimeSlots < ActiveRecord::Migration[8.1]
  def change
    create_table :service_booking_time_slots do |t|
      t.references :service, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :label
      t.integer :service_bookings_count
      t.integer :quantity

      t.timestamps
    end

    add_index :service_booking_time_slots, :start_time
  end
end
