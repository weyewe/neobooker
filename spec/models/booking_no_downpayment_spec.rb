require 'spec_helper'

describe Booking do
  before(:each) do
    Account.setup_business
    @asset_account     = Account.asset_account
    @expense_account   = Account.expense_account
    @revenue_account   = Account.revenue_account
    @liability_account = Account.liability_account
    @equity_account    = Account.equity_account
    
    @cash_account = Account.cash_account 
    @cash_drawer_account = Account.cash_drawer_account 
    @field_usage_revenue_account = Account.field_usage_revenue_account 
    @salvaged_downpayment_revenue_account = Account.salvaged_downpayment_revenue_account  
    @field_booking_downpayment_account = Account.field_booking_downpayment_account 
    
    
    @calendar_amount = BigDecimal('200000')
    @downpayment_percentage = BigDecimal( '20')
    @calendar =  Calendar.create_object({
      :title => "Futsal 1",
      :color => 2 ,
      :amount => @calendar_amount,
      :downpayment_percentage => @downpayment_percentage
    })
    
    @customer = Customer.create_object({
      :name => "Andy"
    })
    
    @number_of_hours = 2 
    @start_datetime =  DateTime.new( 2013, 9, 15, 
                                  17, 0 , 0 
              ) .new_offset( Rational(0,24) )
              
    @booking = Booking.create_object( {
      :calendar_id => @calendar.id , 
      :title => "#{@customer.name} booking",
      :start_datetime => @start_datetime, 
      :number_of_hours => @number_of_hours ,
      :customer_id => @customer.id ,
      :is_downpayment_imposed => false 
    })
    
    # @booking.reload
    
  end
  
  it 'should create booking' do 
    
    puts "\n\n start the test case\n\n"
    @booking.errors.messages.each {|msg| puts msg }
    @booking.should be_valid 
    @booking.is_downpayment_imposed.should be_false
  end
  
 
  
  
  
   
end
