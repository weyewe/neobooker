require 'spec_helper'

describe Booking do
  before(:each) do
    # Account.setup_business
    @current_office = Office.create_object :name => "OFfice1", :description => "balblalbalba", :code => "XXX"
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
    @calendar =  @current_office.calendars.create_object({
      :title => "Futsal 1",
      :color => 2 ,
      :amount => @calendar_amount,
      :downpayment_percentage => @downpayment_percentage
    })
    
    @customer = @current_office.customers.create_object({
      :name => "Andy"
    })
    
    @number_of_hours = 2 
    @start_datetime =  DateTime.new( 2013, 9, 15, 
                                  9, 0 , 0 
              ) .new_offset( Rational(0,24) )
              
    @booking = @current_office.bookings.create_object( {
      :calendar_id => @calendar.id , 
      :title => "#{@customer.name} booking",
      :start_datetime => @start_datetime, 
      :number_of_hours => @number_of_hours ,
      :customer_id => @customer.id ,
      :is_downpayment_imposed => true 
    })
    
    @price_detail = @current_office.price_details.first 
    @booking.reload
    
  end
   
  it 'should create booking'  do
    @booking.should be_valid 
  end
  
  it 'should not confirm booking' do
    @booking.is_confirmed.should be_false 
  end
   
  it 'should not produce 0 downpayment amount' do
    @booking.downpayment_amount.should_not == BigDecimal('0')
  end
  
   
  context "confirming booking"  do
    before(:each) do
      @booking.confirm(nil)
      @booking.reload 
      
      @booking.execute_salvage
      @booking.reload 
      
      @asset_account    .reload 
      @expense_account  .reload 
      @revenue_account  .reload 
      @liability_account.reload 
      @equity_account   .reload 

      @cash_account                         .reload 
      @cash_drawer_account                  .reload 
      @field_usage_revenue_account          .reload 
      @salvaged_downpayment_revenue_account .reload 
      @field_booking_downpayment_account    .reload
      
      @salvage_booking = @booking.salvage_booking
      @salvage_transaction_activity = TransactionActivity.where(
        :transaction_source_id => @salvage_booking.id, 
        :transaction_source_type => @salvage_booking.class.to_s 
      ).first 
      
      
    end
    
    it 'should create salvage booking' do
      @salvage_booking.should be_valid 
    end
    
    it 'should create salvage transaction activity' do
      @salvage_transaction_activity.should be_valid 
    end
    
    it 'should be 2 transaction-activities: 1.downpayment 2. salvage' do
      TransactionActivity.count.should == 2 
    end
    
    it 'should not produce 0 downpayment amount' do
      @booking.downpayment_amount.should_not == BigDecimal('0')
    end
    
    it 'should produce confirmation code' do
      @booking.confirmation_code.length.should_not == 0 
    end
    
    it 'should be salvaged' do
      @booking.is_salvaged?.should be_true
    end
    
       
    
    it 'should create salvage' do
      @salvage_booking.should be_valid 
    end
    
      
    
    it 'should create transaction activity' do
      
      
      @salvage_transaction_activity.should be_valid 
    end
    
    
    
    it 'should create accounting entries' do
      
      @salvage_transaction_activity.transaction_activity_entries.count.should == 2 
      
      @salvage_transaction_activity.is_confirmed.should be_true 
       
      @salvage_transaction_activity.amount.should == @booking.downpayment_amount 
    end
    
=begin
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
=end
    it 'should update the account.s amount ' do
      @downpayment_amount = @booking.downpayment_amount 
      @asset_account  .amount.should == @downpayment_amount
      @expense_account.amount.should == BigDecimal('0')   
      @revenue_account.amount.should == @downpayment_amount
      @liability_account.amount.should ==  BigDecimal('0')
      @equity_account  .amount.should == BigDecimal('0')  
      @cash_account     .amount.should == @downpayment_amount                  
      @cash_drawer_account  .amount.should == @downpayment_amount            
      @field_usage_revenue_account   .amount.should == BigDecimal('0')       
      @salvaged_downpayment_revenue_account .amount.should == @downpayment_amount 
      @field_booking_downpayment_account    .amount.should == BigDecimal('0')
    end
    
    
  end
end
