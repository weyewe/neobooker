class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      
      t.string :title 
      t.integer  :calendar_id 
      t.integer :customer_id 
      
      t.datetime :start_datetime
      t.datetime :end_datetime # end_datetime is derived value
      
      t.integer :duration # (# of hours)
      
      t.datetime :actual_start_datetime
      t.datetime :actual_end_datetime 
      
      t.boolean :is_confirmed , :default => false 
      t.datetime :confirmation_datetime 
      
      t.decimal :discount, :default        => 0,  :precision => 5, :scale => 2 # 999% max.. but it is limited to 100%
      
      # downpayment is derived amount, calculated from facility
      # t.decimal :downpayment_amount , :default        => 0,  :precision => 12, :scale => 2
      
      t.boolean :is_started , :default => false 
      t.boolean :is_finished , :default => false 
      
      t.boolean :is_canceled , :default => false 
      
      # remaining_amount is derived amount, calculated from facility master data. 
      # t.decimal :remaining_amount , :default => 0,  :precision => 12, :scale => 2
      t.boolean :is_paid, :default => false 
      
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