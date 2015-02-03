require 'spec_helper'

describe TransactionActivity do
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
    
  end
   
  
  context "create transaction activity" do
    before(:each) do
      @transaction_datetime = DateTime.now 
      @msg = "Pembayaran hutang bulanan"
      @object = TransactionActivity.create_object({
        :transaction_datetime => @transaction_datetime ,
        :description => @msg 
      }, true )
    end
    
    it 'should create valid transaction activity object' do
      @object.should be_valid 
      @object.transaction_datetime.should == @transaction_datetime
      @object.description.should == @msg 
    end
    
    
    
    it 'should not be allowed to confirm' do
      @object.confirm 
      @object.errors.size.should_not == 0 
      @object.is_confirmed.should be_false 
    end
    
  end
  
end
