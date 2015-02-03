require 'spec_helper'

describe Booking do
  before(:each) do
    # Account.setup_business
    role = {
      :system => {
        :administrator => true
      }
    }

    Role.create!(
      :name        => ROLE_NAME[:admin],
      :title       => 'Administrator',
      :description => 'Role for administrator',
      :the_role    => role.to_json
    )
    @current_office = Office.create_registration_object :name => "OFfice2", :description => "balblalbalba", :code => "XXX", 
            :main_email => "test@gmail.com", :starter_password => "ababa"
    @asset_account     = Account.asset_account(@current_office)
    @expense_account   = Account.expense_account(@current_office)
    @revenue_account   = Account.revenue_account(@current_office)
    @liability_account = Account.liability_account(@current_office)
    @equity_account    = Account.equity_account(@current_office)
    
    @cash_account = Account.cash_account(@current_office) 
    @cash_drawer_account = Account.cash_drawer_account(@current_office) 
    @field_usage_revenue_account = Account.field_usage_revenue_account(@current_office) 
    @salvaged_downpayment_revenue_account = Account.salvaged_downpayment_revenue_account(@current_office)  
    @field_booking_downpayment_account = Account.field_booking_downpayment_account(@current_office) 
    
    
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
      
      
      @booking.pay(nil)
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
      
    end
    
    it 'should pay the booking' do
      @booking.is_paid.should be_true 
    end
    
    it 'should not produce 0 remaining_payment amount' do
      @booking.remaining_amount.should_not == BigDecimal('0')
    end
     
    it 'should create income' do 
      Income.where(
        :income_source_type => @booking.class.to_s,
        :income_source_id => @booking.id, 
        :case => INCOME_CASE[:remaining_payment]
      ).count.should == 1 
       
      @booking.incomes.count.should == 2 

    end
    
     
    it 'should create remaiing_payment income' do
      @booking.downpayment_income.should be_valid 
      @booking.remaining_income.should be_valid
      @booking.incomes.count.should == 2 
    end
    
    it 'should create transaction activity' do
      @booking.remaining_income.transaction_activities.count.should == 1 
    end
    
    
    
    it 'should create accounting entries' do
      @transaction_activity = TransactionActivity.where(
        :transaction_source_id => @booking.remaining_income.id,
        :transaction_source_type => @booking.remaining_income.class.to_s
      ).first 
      
      @transaction_activity.should be_valid 
      @transaction_activity.transaction_activity_entries.count.should == 3 
      
      @transaction_activity.is_confirmed.should be_true 
   
      @transaction_activity.amount.should == @booking.remaining_amount + @booking.downpayment_amount 
    end
  
    it 'should update the account.s amount ' do
      @downpayment_amount = @booking.downpayment_amount 
      @remaining_amount = @booking.remaining_amount 
      @total = @remaining_amount + @downpayment_amount
      
      @asset_account  .amount.should == @total
      @expense_account.amount.should == BigDecimal('0')   
      @revenue_account.amount.should == @total  
      @liability_account.amount.should == BigDecimal('0')
      @equity_account  .amount.should == BigDecimal('0')  
      @cash_account     .amount.should == @total                  
      @cash_drawer_account  .amount.should == @total            
      @field_usage_revenue_account   .amount.should == @total      
      @salvaged_downpayment_revenue_account .amount.should == BigDecimal('0')  
      @field_booking_downpayment_account    .amount.should == BigDecimal('0')
    end
     
    
    
    
  end
end
