require 'spec_helper'

describe Office do
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
    @main_email = "admin@gmail.com"
    @starter_password = "willy1234"
    @current_office = Office.create_registration_object(
                      :is_confirmed        => true    ,        
                      :is_demo             => false    ,
                      :main_email          => @main_email,
                      :starter_password    => @starter_password,
                      :name        => "OFfice1", 
                      :description => "balblalbalba", 
                      :code        => "XXX"

                    )
  end
  
  it "should create main user" do
    User.count.should == 1 
    User.first.office_id.should == @current_office.id 
    User.first.email.should == @current_office.main_email 
  end
  
  context "creating the second office" do
    before(:each) do
      @second_office = Office.create_registration_object(
                        :is_confirmed        => true    ,        
                        :is_demo             => false    ,
                        :main_email          => "banzai@gmail.com",
                        :starter_password    => "banzai1234",
                        :name        => "OFfice2", 
                        :description => "balblalbalba", 
                        :code        => "XXX"

                      )
    end
    
    it "should be valid" do
      @second_office.should be_valid
      @second_office.accounts.count.should_not == 0 
    end
    
    it "should create business specific accounts" do
      @second_office.accounts.where(
          :code  => APP_SPECIFIC_ACCOUNT_CODE[:field_usage_revenue]
      ).count.should == 1 
      
      @second_office.accounts.where(
          :code  => APP_SPECIFIC_ACCOUNT_CODE[:salvaged_downpayment_revenue]
      ).count.should == 1
      
      @second_office.accounts.where(
          :code  => APP_SPECIFIC_ACCOUNT_CODE[:unearned_revenue_booking_downpayment]
      ).count.should == 1
      
    end
  end
end
