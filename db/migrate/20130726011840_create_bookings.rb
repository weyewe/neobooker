class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.string :title 
      t.integer  :calendar_id 
      
      t.datetime :actual_start_datetime
      t.datetime :actual_end_datetime 
      
      t.boolean :is_confirmed , :default => false 
      t.datetime :confirmation_datetime 
      
      t.decimal :downpayment_amount , :default        => 0,  :precision => 12, :scale => 2
      
      t.boolean :is_started , :default => false 
      t.boolean :is_finished , :default => false 
      
      t.boolean :is_canceled , :default => false 
      
      
      t.decimal :remaining_amount , :default => 0,  :precision => 12, :scale => 2
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