require 'spec_helper'

describe PriceRule do
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
    
    
    @number_of_hours = 1
    
    
    @specific_amount = @calendar_amount  *  2
    @specific_price_rule = @current_office.price_rules.create_object(
      :is_sunday         => true ,
      :is_monday         => true ,
      :is_tuesday        => true ,
      :is_wednesday      => true ,
      :is_thursday       => true ,
      :is_friday         => true ,
      :is_saturday       => true ,
      :amount            => @specific_amount   ,
      :rule_case         =>  PRICE_RULE_CASE[:specific]    ,
      :calendar_id       => @calendar.id ,
      :hour_start => 17 , 
      :hour_end => 23 
    )
    
    
    
  end
  
  it 'should create price_rule' do
    @specific_amount = @calendar_amount  *  2
    
    @price_rule = @current_office.price_rules.create_object(
      :is_sunday         => false ,
      :is_monday         => false ,
      :is_tuesday        => false ,
      :is_wednesday      => false ,
      :is_thursday       => false ,
      :is_friday         => true ,
      :is_saturday       => false ,
      :amount            => @specific_amount   ,
      :rule_case         =>  PRICE_RULE_CASE[:specific]    ,
      :calendar_id       => @calendar.id ,
      :hour_start => 17 , 
      :hour_end => 23 
    )
    
    @price_rule.should be_valid 
  end
  
  
  
  context "booking with single price rule, non specific" do
    before(:each) do
      
      
      
      # start at 9 UTC time.. 9+17 == 16 jakarta time.. nothing to do with the specific rule
      @start_datetime =  DateTime.new( 2013, 9, 15, 
                                    9, 0 , 0 
                ) .new_offset( Rational(0,24) )
      
      # puts "@calendar: #{@calendar}"
      @booking = @current_office.bookings.create_object( {
        :calendar_id => @calendar.id , 
        :title => "#{@customer.name} booking",
        :start_datetime => @start_datetime, 
        :number_of_hours => @number_of_hours ,
        :customer_id => @customer.id ,
        :is_downpayment_imposed => true
      })
      
      @booking.errors.messages.each do |x|
        # puts "Error: #{x}"
      end
    end
    
    it 'should create booking with old price' do
      expected_amount = @number_of_hours*@calendar_amount
      # puts "The start date: #{@booking.start_datetime}"
      # puts "actual amount : #{@booking.amount.to_s}"
      # puts "expected amount : #{expected_amount.to_s}"
      @booking.amount.should == expected_amount
    end
  end
  
  context "booking with single price rule,  SPECIFIC price rule" do
    before(:each) do
      
      
      
      # start at 9 UTC time.. 9+17 == 16 jakarta time.. nothing to do with the specific rule
      @start_datetime =  DateTime.new( 2013, 9, 15, 
                                    10, 0 , 0 
                ) .new_offset( Rational(0,24) )
      
      @booking = @current_office.bookings.create_object( {
        :calendar_id => @calendar.id , 
        :title => "#{@customer.name} booking",
        :start_datetime => @start_datetime, 
        :number_of_hours => @number_of_hours ,
        :customer_id => @customer.id ,
        :is_downpayment_imposed => true
      })
      
      
    end
    
    it 'should create booking with new price' do
      expected_amount = @number_of_hours*@specific_amount
      # puts "The start date: #{@booking.start_datetime}"
      # puts "actual amount : #{@booking.amount.to_s}"
      # puts "expected amount : #{expected_amount.to_s}"
      @booking.amount.should == expected_amount
    end 
  end
  
  context "booking with single price rule,  The specific starts at 1700.. our booking is 1630-1730" do
    before(:each) do
      
      
      
      # start at 9 UTC time.. 9+17 == 16 jakarta time.. nothing to do with the specific rule
      @start_datetime =  DateTime.new( 2013, 9, 15, 
                                    9, 0 , 0 
                ) .new_offset( Rational(0,24) )
      
      @booking = @current_office.bookings.create_object( {
        :calendar_id => @calendar.id , 
        :title => "#{@customer.name} booking",
        :start_datetime => @start_datetime, 
        :number_of_hours => @number_of_hours ,
        :customer_id => @customer.id ,
        :is_downpayment_imposed => true
      })
    end
    
    
    
    it 'should create booking with new price' do
      
      expected_amount = @number_of_hours*@calendar_amount  
      @booking.amount.should == expected_amount
    end 
  end
  
  context "booking with 2 prices: first hour at normal price, 2nd hour at special price" do
    before(:each) do 
      # start at 9 UTC time.. 9+17 == 16 jakarta time.. nothing to do with the specific rule
      @start_datetime =  DateTime.new( 2013, 9, 15, 
                                    9, 0 , 0 
                ) .new_offset( Rational(0,24) )
      
      @new_number_of_hours = 2
      @booking = @current_office.bookings.create_object( {
        :calendar_id => @calendar.id , 
        :title => "#{@customer.name} booking",
        :start_datetime => @start_datetime, 
        :number_of_hours => @new_number_of_hours ,
        :customer_id => @customer.id ,
        :is_downpayment_imposed => true
      })
    end
    
    it 'should create booking with new price' do
      expected_amount = 1*@calendar_amount  + 1*@specific_amount
      @booking.amount.should == expected_amount
    end
  end
  
  context "overlapping price_rule: use the latest price rule" do
    before(:each) do
      @new_specific_amount = @specific_amount  *  2
      
      
      @new_price_rule = @current_office.price_rules.create_object(
        :is_sunday         => false ,
        :is_monday         => false ,
        :is_tuesday        => false ,
        :is_wednesday      => false ,
        :is_thursday       => false ,
        :is_friday         => true ,
        :is_saturday       => false ,
        :amount            => @new_specific_amount   ,
        :rule_case         =>  PRICE_RULE_CASE[:specific]    ,
        :calendar_id       => @calendar.id ,
        :hour_start => 17 , 
        :hour_end => 23 
      )
      
      
      @start_datetime =  DateTime.new( 2013, 9, 15, 
                                    9, 0 , 0 
                ) .new_offset( Rational(0,24) )
      
      @new_number_of_hours = 1
      
      
      # I want to book at 18:00.. in utc, it is 11:00
      @start_datetime =  DateTime.new( 2014, 2, 28, 
                                    11, 0 , 0 
                ) .new_offset( Rational(UTC_OFFSET,24) )
                
      # puts "@start_datetime from client input: #{@start_datetime}"
      # puts "@start_datetime in the server: #{@start_datetime.utc}"
      
      @booking = @current_office.bookings.create_object( {
        :calendar_id => @calendar.id , 
        :title => "#{@customer.name} booking",
        :start_datetime => @start_datetime.utc, 
        :number_of_hours => 1 ,
        :customer_id => @customer.id ,
        :is_downpayment_imposed => true
      })
      
     
    end
    
    it 'should use the latest price rule' do
      @booking.price_details.count.should == 1 
      @booking.price_details.first.price_rule.id.should == @new_price_rule.id
    end
  end
  


end
