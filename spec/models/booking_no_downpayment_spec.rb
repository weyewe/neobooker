require 'spec_helper'

describe Booking do
  before(:each) do
    # @current_office.accounts.setup_business
    @current_office = Office.create_object :name => "OFfice1", :description => "balblalbalba", :code => "XXX"
    
    @asset_account     = @current_office.accounts.asset_account
    @expense_account   = @current_office.accounts.expense_account
    @revenue_account   = @current_office.accounts.revenue_account
    @liability_account = @current_office.accounts.liability_account
    @equity_account    = @current_office.accounts.equity_account
    
    @cash_account = @current_office.accounts.cash_account 
    @cash_drawer_account = @current_office.accounts.cash_drawer_account 
    @field_usage_revenue_account = @current_office.accounts.field_usage_revenue_account 
    @salvaged_downpayment_revenue_account = @current_office.accounts.salvaged_downpayment_revenue_account  
    @field_booking_downpayment_account = @current_office.accounts.field_booking_downpayment_account 
    
    
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
                                  8, 0 , 0 
              ) .new_offset( Rational(0,24) )
              
              
              
    @booking = @current_office.bookings.create_object( {
      :calendar_id => @calendar.id , 
      :title => "#{@customer.name} booking",
      :start_datetime => @start_datetime, 
      :number_of_hours => @number_of_hours ,
      :customer_id => @customer.id ,
      :is_downpayment_imposed => false 
    })
    
    
    # @booking.errors.messages.each {|x| puts x}
    # local_datetime = @start_datetime.in_time_zone("Jakarta") 
    # puts "start_datetime: #{@start_datetime}"
    # puts "Local datetime: #{local_datetime}"
    
  end
  
  it 'should create booking' do 
    
    @booking.errors.messages.each {|msg| puts msg }
    # @booking.should be_valid 
    # @booking.is_downpayment_imposed.should be_false
  end
  
  
  it 'should give no downpamyent' do
    @booking.downpayment_amount.should == BigDecimal('0')
  end
  
  context "confirm booking" do
    before(:each) do
      @booking.confirm(nil)
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
        @booking.pay(nil)
        @booking.reload 
        
        @income = @booking.incomes.first 
        
        @current_office.reload 
        
        @transaction_activity = @current_office.transaction_activities.where(
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
        
        # puts "The id 23324234: #{@transaction_activity.office_id}"
      end
      
      it 'should create 2 transaction entries' do
        
        @transaction_activity.transaction_activity_entries.count.should == 2 
        
        # @cash_drawer_account = @current_office.accounts.cash_drawer_account 
        # @field_usage_revenue_account = @current_office.accounts.field_usage_revenue_account
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
