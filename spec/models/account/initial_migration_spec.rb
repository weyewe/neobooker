require 'spec_helper'

describe Account do


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
    
    # @current_office.accounts.setup_business
    @asset_account     = @current_office.accounts.asset_account(@current_office)
    @expense_account   = @current_office.accounts.expense_account(@current_office)
    @revenue_account   = @current_office.accounts.revenue_account(@current_office)
    @liability_account = @current_office.accounts.liability_account(@current_office)
    @equity_account    = @current_office.accounts.equity_account(@current_office)
    @cash_drawer_account = @current_office.accounts.cash_drawer_account(@current_office)
    @cash_account = @current_office.accounts.cash_account(@current_office) 
    @field_usage_revenue_account = @current_office.accounts.field_usage_revenue_account(@current_office)
    @salvaged_downpayment_revenue_account = @current_office.accounts.salvaged_downpayment_revenue_account(@current_office)
    @field_booking_downpayment_account = @current_office.accounts.field_booking_downpayment_account(@current_office)
    
  end
  
  it "should create current_office" do
    @current_office.should be_valid
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
    # 
    # context "create migration" do
    #   before(:each) do
    #     @initial_amount = BigDecimal('500000')
    #     @cash_drawer_account.create_initial_amount(:initial_amount => @initial_amount)
    #     @transaction_activity = @current_office.transaction_activities.where(
    #       :transaction_source_id => @cash_drawer_account.id ,
    #       :transaction_source_type => @cash_drawer_account.class.to_s ).first
    #       
    #     @cash_drawer_account.reload 
    #     @cash_account.reload
    #     @asset_account.reload 
    #     @transaction_activity.reload 
    #   end
    #   
    #   
    #   it 'should have created transaction_activity' do
    #     @cash_drawer_account.initial_amount_transaction_activity.should be_valid 
    #   end
    #   
    #   it 'should produced the same transaction activity' do
    #     @transaction_activity.id.should == @cash_drawer_account.initial_amount_transaction_activity.id 
    #   end
    #   
    #   it 'should create the shite' do
    #     @cash_drawer_account.errors.size.should == 0 
    #   end
    #   
    #   it 'should allow transaction_activity_confirmation' do
    #     @transaction_activity.confirm
    #     puts "Total error count: #{@transaction_activity.errors.size}"
    #     @transaction_activity.errors.messages.each do |msg|
    #       puts msg 
    #     end
    #     
    #     
    #     @transaction_activity.is_confirmed.should be_true 
    #   end
    #    
    #   
    #   it 'should update the amount of cash_drawer_account, cash_account, and asset_account' do
    #     @cash_drawer_account.amount.should == @initial_amount
    #     @cash_account.amount.should == @initial_amount
    #     @asset_account.amount.should == @initial_amount
    #   end
    #   
    #   it 'should update the temporary transaction amount' do
    #     @cash_drawer_account.reload 
    #     temporary_account = @cash_drawer_account.temporary_account
    #     temporary_account.amount.should == @initial_amount
    #   end
    #   
    #   context "update initial migration" do
    #     before(:each) do
    #       @final_amount = @initial_amount + BigDecimal('300000')
    #       @cash_drawer_account.create_initial_amount(:initial_amount => @final_amount)
    #       
    #       @cash_drawer_account.reload 
    #       @cash_account.reload
    #       @asset_account.reload 
    #       @transaction_activity.reload
    #     end
    #     
    #     it 'should be valid' do
    #       @cash_drawer_account.errors.size.should == 0 
    #       @cash_drawer_account.amount.should == @final_amount
    #       @cash_account.amount.should == @final_amount
    #       @asset_account.amount.should == @final_amount
    #     end
    #     
    #     it 'should have confirmed the transaction_activity' do
    #       @transaction_activity.is_confirmed.should be_true 
    #     end
    #   end
    # 
    #    
    # end
    # 
    # 
  
  
  
end
