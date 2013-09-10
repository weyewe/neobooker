require 'spec_helper'

describe Account do


  before(:each) do
    Account.setup_business
    @asset_account     = Account.asset_account
    @expense_account   = Account.expense_account
    @revenue_account   = Account.revenue_account
    @liability_account = Account.liability_account
    @equity_account    = Account.equity_account 
    @cash_drawer_account = Account.cash_drawer_account
    @cash_account = Account.cash_account 
    @field_usage_revenue_account = Account.field_usage_revenue_account
    @salvaged_downpayment_revenue_account = Account.salvaged_downpayment_revenue_account
    @field_booking_downpayment_account = Account.field_booking_downpayment_account
    
  end
  
  it 'should create cash_drawer + cash  + field_usage_revenue_account+ salvaged_downpayment_revenue_account+ field_booking_downpayment_account account' do
    @cash_drawer_account                  .should be_valid
    @cash_account                         .should be_valid
    @field_usage_revenue_account          .should be_valid
    @salvaged_downpayment_revenue_account .should be_valid
    @field_booking_downpayment_account    .should be_valid                                                                            
  end
  
  it 'should not allow migration on group account' do
    @asset_account.account_case.should == ACCOUNT_CASE[:group]
    @asset_account.create_initial_amount(:initial_amount => BigDecimal('500000'))
    @asset_account.errors.size.should_not == 0 
  end
  
  context "create migration" do
    before(:each) do
      @initial_amount = BigDecimal('500000')
      @cash_drawer_account.create_initial_amount(:initial_amount => @initial_amount)
      @transaction_activity = TransactionActivity.where(
        :transaction_source_id => @cash_drawer_account.id ,
        :transaction_source_type => @cash_drawer_account.class.to_s ).first
        
      @cash_drawer_account.reload 
      @cash_account.reload
      @asset_account.reload 
      @transaction_activity.reload 
    end
    
    
    it 'should have created transaction_activity' do
      @cash_drawer_account.initial_amount_transaction_activity.should be_valid 
    end
    
    it 'should produced the same transaction activity' do
      @transaction_activity.id.should == @cash_drawer_account.initial_amount_transaction_activity.id 
    end
    
    it 'should create the shite' do
      @cash_drawer_account.errors.size.should == 0 
    end
    
    it 'should allow transaction_activity_confirmation' do
      @transaction_activity.confirm
      puts "Total error count: #{@transaction_activity.errors.size}"
      @transaction_activity.errors.messages.each do |msg|
        puts msg 
      end
      
      
      @transaction_activity.is_confirmed.should be_true 
    end
     
    
    it 'should update the amount of cash_drawer_account, cash_account, and asset_account' do
      @cash_drawer_account.amount.should == @initial_amount
      @cash_account.amount.should == @initial_amount
      @asset_account.amount.should == @initial_amount
    end
    
    it 'should update the temporary transaction amount' do
      @cash_drawer_account.reload 
      temporary_account = @cash_drawer_account.temporary_account
      temporary_account.amount.should == @initial_amount
    end
    
    context "update initial migration" do
      before(:each) do
        @final_amount = @initial_amount + BigDecimal('300000')
        @cash_drawer_account.create_initial_amount(:initial_amount => @final_amount)
        
        @cash_drawer_account.reload 
        @cash_account.reload
        @asset_account.reload 
        @transaction_activity.reload
      end
      
      it 'should be valid' do
        @cash_drawer_account.errors.size.should == 0 
        @cash_drawer_account.amount.should == @final_amount
        @cash_account.amount.should == @final_amount
        @asset_account.amount.should == @final_amount
      end
      
      it 'should have confirmed the transaction_activity' do
        @transaction_activity.is_confirmed.should be_true 
      end
    end
  
     
  end
  
  
  
  
  
end
