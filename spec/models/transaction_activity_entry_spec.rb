require 'spec_helper'

describe TransactionActivityEntry do
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
    
    
    @transaction_datetime =DateTime.now 
    @msg = "Pembayaran hutang bulanan"
    
    
    @transaction_activity = TransactionActivity.create_object({
      :transaction_datetime => @transaction_datetime ,
      :description => @msg 
    }, true )
    @cash_drawer_account = Account.cash_drawer_account(@current_office)
    @field_usage_revenue_account = Account.field_usage_revenue_account(@current_office)
    
    @revenue_amount = BigDecimal("300000")
    
    
  end
  
  it 'should create transaction activity' do
    @transaction_activity.should be_valid 
  end
  
  it 'should create transaction_activity_entry' do
    @te_entry= TransactionActivityEntry.create_object({
      :transaction_activity_id => @transaction_activity.id ,
      :account_id => @cash_drawer_account.id ,
      :entry_case =>  NORMAL_BALANCE[:debit],
      :amount => @revenue_amount
    })
    
    @te_entry.should be_valid 
    @transaction_activity.transaction_activity_entries.count.should == 1 
    
    @transaction_activity.transaction_activity_entries.
                    where(:entry_case => NORMAL_BALANCE[:debit]).count.should == 1 
  end
  
  context "creating first tranasction_activity_entry" do
    before(:each) do
      @te_entry= TransactionActivityEntry.create_object({
        :transaction_activity_id => @transaction_activity.id ,
        :account_id => @cash_drawer_account.id ,
        :entry_case =>  NORMAL_BALANCE[:debit],
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
    
    context "creating the second transactionEntry" do
      before(:each) do
        @te_entry_2 = TransactionActivityEntry.create_object({
          :transaction_activity_id => @transaction_activity.id ,
          :account_id => @field_usage_revenue_account.id ,
          :entry_case =>  NORMAL_BALANCE[:credit],
          :amount => @revenue_amount
        })
        
      end
      
      it 'should create @te_entry2' do
        @te_entry_2.should be_valid 
      end
      
      
      context "confirming the transaction" do
        before(:each) do
          @revenue_account   = Account.revenue_account(@current_office)
          @field_usage_revenue_account = Account.field_usage_revenue_account(@current_office)
          @asset_account     = Account.asset_account(@current_office) 
          @cash_account = Account.cash_account(@current_office)
          @cash_drawer_account = Account.cash_drawer_account(@current_office)
      
          @initial_cash_drawer_account = @cash_drawer_account.amount
          @initial_cash_account = @cash_account.amount 
          @initial_asset_account = @asset_account.amount 
          
          @initial_revenue_account = @revenue_account.amount 
          @initial_field_usage_revenue_account = @field_usage_revenue_account.amount 
      
      
      
          @transaction_activity.reload 
          @transaction_activity.confirm 
          @transaction_activity.reload 
      
      
          @cash_drawer_account.reload 
          @cash_account.reload 
          @asset_account.reload
          @revenue_account.reload 
          @field_usage_revenue_account.reload 
          
          @final_cash_drawer_account = @cash_drawer_account.amount
          @final_cash_account = @cash_account.amount 
          @final_asset_account = @asset_account.amount
          @final_revenue_account = @revenue_account.amount 
          @final_field_usage_revenue_account = @field_usage_revenue_account.amount 
          
        end
      
        it "should update the account's amount + account's account's amount" do
          
          
          diff_cash_drawer = @final_cash_drawer_account - @initial_cash_drawer_account
          diff_cash = @final_cash_account - @initial_cash_account
          diff_asset = @final_asset_account - @initial_asset_account
          
          diff_revenue = @final_revenue_account - @initial_revenue_account
          diff_field_usage_revenue = @final_field_usage_revenue_account - @initial_field_usage_revenue_account
      
       
          diff_cash_drawer.should == @revenue_amount
          diff_cash.should == @revenue_amount
          diff_asset.should == @revenue_amount
          diff_revenue.should == @revenue_amount
          diff_field_usage_revenue.should == @revenue_amount
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
      
        it 'should not be allowed to update object' do
          @te_entry_2.update_object({
            :transaction_activity_id => @transaction_activity.id ,
            :account_id => @field_usage_revenue_account.id ,
            :entry_case =>  NORMAL_BALANCE[:credit],
            :amount => @revenue_amount + BigDecimal('1000')
          })
      
          @te_entry_2.errors.size.should_not == 0 
        end
      
        it 'should not be allowed to create more transaction activity entry' do
          @te_entry_3 = TransactionActivityEntry.create_object({
            :transaction_activity_id => @transaction_activity.id ,
            :account_id => @field_usage_revenue_account.id ,
            :entry_case =>  NORMAL_BALANCE[:credit],
            :amount => @revenue_amount + BigDecimal("8000")
          })
      
          @te_entry_3.errors.size.should_not == 0 
        end
      
        context "UNCONFIRM transaction_activity" do
          before(:each) do
            
            
            # puts "\n\nThis is the latest awesome\n\n"
            # puts "===============================\n\n"
            
            @transaction_activity.unconfirm
            
            @cash_drawer_account.reload 
            @cash_account.reload 
            @asset_account.reload
            @revenue_account.reload 
            @field_usage_revenue_account.reload
            
            @post_unconfirm_cash_drawer_account         = @cash_drawer_account.amount
            @post_unconfirm_cash_account                = @cash_account.amount 
            @post_unconfirm_asset_account               = @asset_account.amount
            @post_unconfirm_revenue_account             = @revenue_account.amount 
            @post_unconfirm_field_usage_revenue_account = @field_usage_revenue_account.amount

          end
              
          it "should reduce the account's amount" do
            
            
            @post_unconfirm_cash_drawer_account         .should == BigDecimal('0')
            @post_unconfirm_cash_account                .should == BigDecimal('0')
            @post_unconfirm_asset_account               .should == BigDecimal('0')
            @post_unconfirm_revenue_account             .should == BigDecimal('0')
            @post_unconfirm_field_usage_revenue_account .should == BigDecimal('0')
            
            
            
            
            
            diff_cash_drawer =         @post_unconfirm_cash_drawer_account         - @final_cash_drawer_account         
            diff_cash =                @post_unconfirm_cash_account                - @final_cash_account               
            diff_asset =               @post_unconfirm_asset_account               - @final_asset_account              
            diff_revenue =             @post_unconfirm_revenue_account             - @final_revenue_account            
            diff_field_usage_revenue = @post_unconfirm_field_usage_revenue_account - @final_field_usage_revenue_account
            
            
            
            diff_cash_drawer          .should == @revenue_amount*-1       
            diff_cash                 .should == @revenue_amount*-1
            diff_asset                .should == @revenue_amount*-1
            diff_revenue              .should == @revenue_amount*-1
            diff_field_usage_revenue  .should == @revenue_amount*-1
          end
              
        end
      
      end

    end

    
    
  end
  

  

  

   
end
