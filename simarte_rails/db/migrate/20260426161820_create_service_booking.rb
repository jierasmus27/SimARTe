class CreateServiceBooking < ActiveRecord::Migration[8.1]
  def change
    create_table :service_bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :service_booking_time_slot, null: false, foreign_key: true

      t.timestamps
    end

    add_index :service_bookings, %i[user_id service_booking_time_slot_id], unique: true
  end
end
