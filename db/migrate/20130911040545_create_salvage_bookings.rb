class CreateSalvageBookings < ActiveRecord::Migration
  def change
    create_table :salvage_bookings do |t|
      t.integer :booking_id 
      t.datetime :salvaged_datetime 
      
      
      t.timestamps
    end
  end
end
