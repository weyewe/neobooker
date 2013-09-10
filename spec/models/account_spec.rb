require 'spec_helper'

describe Account do
  
  context "base accounts creation" do
    before(:each) do
      @asset_account     = Account.create_asset
      @expense_account   = Account.create_expense
      @revenue_account   = Account.create_revenue
      @liability_account = Account.create_liability
      @equity_account    = Account.create_equity

    end

    it 'should create 5 base accounts' do 
      @asset_account    .should be_valid
      @expense_account  .should be_valid
      @revenue_account  .should be_valid
      @liability_account.should be_valid
      @equity_account   .should be_valid
    end
  end
  
  context "business accounts creation" do
    before(:each) do
      Account.setup_business
    end
    
    it 'should create 5 base objects' do
      Account.where(:is_base_account =>true ).count.should == 5
    end
    
    it 'should create business objects' do
      # 1. cash_account
      # 2. cash_drawer
      # 3. field_usage_revenue 
      # 4. salvaged_downpayment_revenue 
      # 5. field_booking_downpayment 
      
      Account.cash_account.should be_valid 
      Account.cash_drawer_account.should be_valid
      Account.field_usage_revenue_account.should be_valid 
      Account.salvaged_downpayment_revenue_account.should be_valid 
      Account.field_booking_downpayment_account.should be_valid 
    end
    
    it 'should give asset_account 2 children : cash_drawer and cash' do
      @asset_account = Account.asset_account
=begin
descendants  => all childs down the tree
children => direct children (1 depth below)
self_and_descendants
is_descendant_of?
is_or_is_descendant_of?
is_ancestor_of?
is_or_is_ancestor_of?
same_scope?
=end
      
      # puts @asset_account.methods
      @asset_account.descendants.count.should ==  2
      @asset_account.children.count.should == 1 
      
      @cash_drawer_account = @asset_account.descendants.where(:code => APP_SPECIFIC_ACCOUNT_CODE[:cash_drawer]).first
      @cash_account  =  @asset_account.descendants.where(:code => APP_SPECIFIC_ACCOUNT_CODE[:cash]).first

      @cash_drawer_account.is_descendant_of?( @cash_account).should be_true 
      
      @cash_drawer_account.is_descendant_of?( @asset_account).should be_true 
      @cash_account.is_descendant_of?( @asset_account).should be_true 
    end
    
    it 'should give liability a descendant: downpayment_revenue' do
      @liability_account = Account.liability_account 
      @liability_account.descendants.count.should == 1 
      
      @downpayment_unearned_revenue_account = Account.field_booking_downpayment_account
      
      @downpayment_unearned_revenue_account.is_descendant_of?(@liability_account).should be_true 
    end
    
    it 'should create 2 descendants of revenue account' do
      @field_usage_revenue = Account.field_usage_revenue_account 
      @salvaged_downpayment_revenue = Account.salvaged_downpayment_revenue_account 
      
      @revenue = Account.revenue_account
      @revenue.descendants.count.should == 2 
      @field_usage_revenue.is_descendant_of?(@revenue).should be_true 
      @salvaged_downpayment_revenue.is_descendant_of?(@revenue).should be_true 
    end
  
  end
  
  
  
end
