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
    
    @booking.errors.messages.each {|msg| puts msg }
    @booking.should be_valid 
    @booking.is_downpayment_imposed.should be_false
  end
  
  
  it 'should give no downpamyent' do
    @booking.downpayment_amount.should == BigDecimal('0')
  end
  
  context "confirm booking" do
    before(:each) do
      @booking.confirm
      @booking.reload 
    end
    
    it 'should be confirmed' do
      @booking.is_confirmed.should be_true 
    end
    
    it 'should produce no income' do
      @booking.incomes.count.should == 0 
    end
    
    it 'should not be allowed to be updated if it changes the is_downpayment_imposed' do
      @booking.update_object({
        :calendar_id => @calendar.id , 
        :title => "#{@customer.name} latest",
        :start_datetime => @start_datetime, 
        :number_of_hours => @number_of_hours ,
        :customer_id => @customer.id,
        :is_downpayment_imposed => true
      })
      
      @booking.errors.size.should_not == 0 
    end
    
    context "perform payment" do
      before(:each) do
        @booking.pay 
        @booking.reload 
        
        @income = @booking.incomes.first 
        @transaction_activity = TransactionActivity.where(
          :transaction_source_id => @income.id ,
          :transaction_source_type => @income.class.to_s
        ).first
      end
      
      it 'should be marked as paid' do
        @booking.is_paid.should be_true
      end
      
      it 'should create income' do
        @booking.incomes.count.should == 1 
      end
      
      it 'should give full amount as income' do
        @booking.remaining_amount.should == @income.amount 
      end
      
      it 'should produce transaction_activity' do
        @transaction_activity.should be_valid 
      end
      
      it 'should create 2 transaction entries' do
        
        @transaction_activity.transaction_activity_entries.count.should == 2 
        
        # @cash_drawer_account = Account.cash_drawer_account 
        # @field_usage_revenue_account = Account.field_usage_revenue_account
        @transaction_activity.transaction_activity_entries.where(
          :account_id => @cash_drawer_account,
          :entry_case => NORMAL_BALANCE[:debit]
        ).count.should == 1 
        
        @transaction_activity.transaction_activity_entries.where(
          :account_id => @field_usage_revenue_account,
          :entry_case => NORMAL_BALANCE[:credit]
        ).count.should == 1
        
        @transaction_activity.transaction_activity_entries.where(
          :account_id => @cash_drawer_account,
          :entry_case => NORMAL_BALANCE[:debit]
        ).first.amount.should == @booking.remaining_amount
      end
      
      
      
      
    end
  end
 
  
  
  
   
end
