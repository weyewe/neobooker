require 'spec_helper'

describe TransactionActivityEntry do
  before(:each) do
    Account.setup_business
    
    @transaction_datetime =DateTime.now 
    @msg = "Pembayaran hutang bulanan"
    
    
    @transaction_activity = TransactionActivity.create_object({
      :transaction_datetime => @transaction_datetime ,
      :description => @msg 
    })
    @cash_drawer_account = Account.cash_drawer
    @field_usage_revenue_account = Account.field_usage_revenue
    
    @revenue_amount = BigDecimal("300000")
    # TRANSACTION_ACTIVITY_ENTRY_CASE
  end
  
  it 'should create transaction activity' do
    @transaction_activity.should be_valid 
  end
  
  it 'should create transaction_activity_entry' do
    @te_entry= TransactionActivityEntry.create_object({
      :transaction_activity_id => @transaction_activity.id ,
      :account_id => @cash_drawer_account.id ,
      :entry_case =>  TRANSACTION_ACTIVITY_ENTRY_CASE[:debit],
      :amount => @revenue_amount
    })
    
    @te_entry.should be_valid 
    @transaction_activity.transaction_activity_entries.count.should == 1 
    
    @transaction_activity.transaction_activity_entries.
                    where(:entry_case => TRANSACTION_ACTIVITY_ENTRY_CASE[:debit]).count.should == 1 
  end
  
  context "creating first tranasction_activity_entry" do
    before(:each) do
      @te_entry= TransactionActivityEntry.create_object({
        :transaction_activity_id => @transaction_activity.id ,
        :account_id => @cash_drawer_account.id ,
        :entry_case =>  TRANSACTION_ACTIVITY_ENTRY_CASE[:debit],
        :amount => @revenue_amount
      })
    end
    
    it 'should generate transaction_activity.total_debit' do


      @transaction_activity.total_debit.should_not == BigDecimal('0')
      @transaction_activity.total_debit.should == @revenue_amount 
    end
    
    it 'should not allow transaction_activity confirmation' do
      @transaction_activity.confirm 
      @transaction_activity.errors.size.should_not == 0 
      @transaction_activity.is_confirmed.should be_false 
    end
    
    context "confirming the transaction" do
      before(:each) do
        @te_entry_2 = TransactionActivityEntry.create_object({
          :transaction_activity_id => @transaction_activity.id ,
          :account_id => @field_usage_revenue_account.id ,
          :entry_case =>  TRANSACTION_ACTIVITY_ENTRY_CASE[:credit],
          :amount => @revenue_amount
        })

        @transaction_activity.reload 
        @transaction_activity.confirm 
        @transaction_activity.reload 
      end

      it 'should create the 2nd transaction_activity_entry' do
        @te_entry_2.should be_valid 
      end

      it 'should confirm the transaction activity' do
        @transaction_activity.errors.messages.each do |msg|
          puts msg
        end
        @transaction_activity.is_confirmed.should be_true 
      end
      
      it 'should generate amount in the transaction activity' do
        @transaction_activity.amount.should == @transaction_activity.total_debit 
      end

    end
    
    
    
  end
  

  

  

   
end
