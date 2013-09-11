class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      
      # t.string :title 
      t.integer  :calendar_id 
      t.integer :customer_id 
      
      t.integer :price_id 
      
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.integer :number_of_hours 
      
      # t.datetime :end_datetime # end_datetime is derived value
      
      # t.integer :duration # (# of hours)
      
      t.datetime :actual_start_datetime
      t.datetime :actual_end_datetime 
      
      t.boolean :is_confirmed , :default => false 
      t.datetime :confirmed_datetime 
      
      t.decimal :discount, :default        => 0,  :precision => 5, :scale => 2 # 999% max.. but it is limited to 100%
      # A field with precision 5, scale 2 must round to an absolute value less than 10^3.
      
      
      # downpayment is derived amount, calculated from facility
      # t.decimal :downpayment_amount , :default        => 0,  :precision => 12, :scale => 2
      
      t.boolean :is_started , :default => false 
      t.boolean :is_finished , :default => false 
      
      t.boolean :is_canceled , :default => false 
      t.boolean :is_deleted , :default => false 
      
      # t.decimal :received_amount , :default => 0,  :precision => 12, :scale => 2
      t.boolean :is_paid, :default => false 
      t.datetime :paid_datetime 
      
     
      
      t.decimal :amount,  :default        => 0,  :precision => 12, :scale => 2 
      
      t.boolean :is_downpayment_imposed , :default => true  
      
      
      # code to be printed @ receipt 
      
      t.string :code 
      t.string :booking_code 
      
      
      t.timestamps
    end
  end
end


=begin
steps:
1. create customer (if there is no customer)
2. create booking 
3.  confirm booking (with downpayment)
4.  start usage (start datetime)
5.  finish usage (finish datetime)
6.  create payment (remaining payment)


=======> DONE 
=end