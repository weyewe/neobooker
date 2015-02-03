require 'spec_helper'

describe Account do
   
  
  context "base accounts creation" do
    before(:each) do
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
      
      @current_office = Office.create_registration_object :name => "OFfice1", :description => "balblalbalba", :code => "XXX", 
              :main_email => "test@gmail.com", :starter_password => "ababa"
      
      @asset_account     = Account.asset_account(@current_office)
      @expense_account   = Account.expense_account(@current_office)
      @revenue_account   = Account.revenue_account(@current_office)
      @liability_account = Account.liability_account(@current_office)
      @equity_account    = Account.equity_account(@current_office)


    end
    
    it "should create valid office" do
      @current_office.errors.messages.each {|x| puts x}
      @current_office.should be_valid 
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
      
    end
    
    it 'should create 5 base objects' do
      @current_office.accounts.where(:is_base_account =>true ).count.should == 7
    end
    
    it 'should create 2 temporary accounts' do
      @current_office.accounts.where(:is_temporary_account => true).count.should ==  2
    end
    
    it "temporary_account of normal_balance debit account should be temporary_credit_account" do
      @asset_account.temporary_account.normal_balance.should == NORMAL_BALANCE[:credit]
      @liability_account.temporary_account.normal_balance.should == NORMAL_BALANCE[:debit]
    end
    
    it 'should create business objects' do
      # 1. cash_account
      # 2. cash_drawer
      # 3. field_usage_revenue 
      # 4. salvaged_downpayment_revenue 
      # 5. field_booking_downpayment 
      
      Account.cash_account(@current_office).should be_valid 
      Account.cash_drawer_account(@current_office).should be_valid
      Account.field_usage_revenue_account(@current_office).should be_valid 
      Account.salvaged_downpayment_revenue_account(@current_office).should be_valid 
      Account.field_booking_downpayment_account(@current_office).should be_valid 
    end
    
    it 'should give asset_account 2 children : cash_drawer and cash' do
      @asset_account = Account.asset_account(@current_office)
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
      @liability_account = Account.liability_account(@current_office)
      @liability_account.descendants.count.should == 1 
      
      @downpayment_unearned_revenue_account = Account.field_booking_downpayment_account(@current_office)
      
      @downpayment_unearned_revenue_account.is_descendant_of?(@liability_account).should be_true 
    end
    
    it 'should create 2 descendants of revenue account' do
      @field_usage_revenue = Account.field_usage_revenue_account(@current_office)
      @salvaged_downpayment_revenue = Account.salvaged_downpayment_revenue_account(@current_office)
      
      @revenue = Account.revenue_account(@current_office)
      @revenue.descendants.count.should == 2 
      @field_usage_revenue.is_descendant_of?(@revenue).should be_true 
      @salvaged_downpayment_revenue.is_descendant_of?(@revenue).should be_true 
    end
  
  end
  
  
  
end
