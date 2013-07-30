class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.string :title 
      t.string  :calendar_id 
      
      t.timestamps
    end
  end
end
