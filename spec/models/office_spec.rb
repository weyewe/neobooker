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
end
