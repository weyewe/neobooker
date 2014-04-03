require 'spec_helper'

describe PriceRule do
  before(:each) do
    Account.setup_business
    @calendar_amount = BigDecimal('75000')
    @downpayment_percentage = BigDecimal( '30')
    @calendar =  Calendar.create_object({
      :title => "Futsal 1",
      :color => 2 ,
      :amount => @calendar_amount,
      :downpayment_percentage => @downpayment_percentage
    })
    
    @customer = Customer.create_object({
      :name => "Andy"
    })
    
    
    @number_of_hours = 1
    
    
    @specific_amount = @calendar_amount  *  2
    @specific_price_rule = PriceRule.create_object(
      :is_sunday         => true ,
      :is_monday         => false ,
      :is_tuesday        => false ,
      :is_wednesday      => false ,
      :is_thursday       => false ,
      :is_friday         => false ,
      :is_saturday       => true ,
      :amount            => @specific_amount   ,
      :rule_case         =>  PRICE_RULE_CASE[:specific]    ,
      :calendar_id       => @calendar.id ,
      :hour_start => 0 , 
      :hour_end => 23 
    )
    
    @specific_amount_2 = @calendar_amount  *  2
    @specific_price_rule_2 = PriceRule.create_object(
      :is_sunday         => false ,
      :is_monday         => true ,
      :is_tuesday        => true ,
      :is_wednesday      => true ,
      :is_thursday       => true ,
      :is_friday         => true ,
      :is_saturday       => false ,
      :amount            => @specific_amount_2   ,
      :rule_case         =>  PRICE_RULE_CASE[:specific]    ,
      :calendar_id       => @calendar.id ,
      :hour_start => 16 , 
      :hour_end => 23 
    )
  end
  
  # it 'should have 3 price rules' do
  #   @calendar.price_rules.count.should == 3 
  # end
  # 
  # context "booking made" do
  #   before(:each) do
  #     
  #     
  #     
  #     # Do booking at 9am jakarta time.. 2 am UTC time
  #     @start_datetime =  DateTime.new( 2014, 2, 25, 
  #                                   2, 0 , 0 
  #               ) .new_offset( Rational(UTC_OFFSET,24) )
  #               
  #     puts "@start_datetime from client input: #{@start_datetime}"
  #     puts "@start_datetime in the server: #{@start_datetime.utc}"
  #     
  #     @booking = Booking.create_object( {
  #       :calendar_id => @calendar.id , 
  #       :title => "#{@customer.name} booking",
  #       :start_datetime => @start_datetime.utc, 
  #       :number_of_hours => @number_of_hours ,
  #       :customer_id => @customer.id ,
  #       :is_downpayment_imposed => true
  #     })
  #     
  #     @catch_all_price_rule  = @calendar.price_rules.where(:rule_case => PRICE_RULE_CASE[:catch_all]  ).first
  #     
  #   end
  #   
  #   it 'should create booking with catch-all price' do 
  #     @booking.price_details.count.should == 1 
  #     
  #     # @booking.price_details.first.price_rule.rule_case.should == PRICE_RULE_CASE[:specific] 
  #     @booking.price_details.first.price_rule.id.should == @catch_all_price_rule.id
  #   end
  # end
  # 
  # 
  # 
  # context "booking with single price rule,  SPECIFIC price rule" do
  #   before(:each) do
  #     
  #     
  #     
  #     # start at 9 UTC time.. 9+17 == 16 jakarta time.. nothing to do with the specific rule
  #     @start_datetime =  DateTime.new( 2013, 9, 15, 
  #                                   10, 0 , 0 
  #               ) .new_offset( Rational(0,24) )
  #     
  #     @booking = Booking.create_object( {
  #       :calendar_id => @calendar.id , 
  #       :title => "#{@customer.name} booking",
  #       :start_datetime => @start_datetime, 
  #       :number_of_hours => @number_of_hours ,
  #       :customer_id => @customer.id ,
  #       :is_downpayment_imposed => true
  #     })
  #   end
  #   
  #   it 'should create booking with new price' do
  #     expected_amount = @number_of_hours*@specific_amount
  #     puts "The start date: #{@booking.start_datetime}"
  #     puts "actual amount : #{@booking.amount.to_s}"
  #     puts "expected amount : #{expected_amount.to_s}"
  #     @booking.amount.should == expected_amount
  #   end 
  # end
  # 
  context "booking with single price rule,  The specific starts at 1700.. our booking is 1630-1730" do
    before(:each) do
      
      
      
      # start at 9 UTC time.. 9+17 == 16 jakarta time.. nothing to do with the specific rule
      # what day is 2013/9/15 == Sunday
      # of course, it will use @specific_price_rule
      @start_datetime =  DateTime.new( 2013, 9, 15, 
                                    9, 30 , 0 
                ) .new_offset( Rational(0,24) )
      
      @booking = Booking.create_object( {
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
      @booking.amount.should == expected_amount
    end 
  end
  
  context "booking with 2 prices: first hour at normal price, 2nd hour at special price" do
    before(:each) do 
      # start at 9 UTC time.. 9+17 == 16 jakarta time.. nothing to do with the specific rule
      # on sunday, the rule doesn't apply 
      @start_datetime =  DateTime.new( 2013, 9, 15, 
                                    9, 30 , 0 
                ) .new_offset( Rational(0,24) )
      
      @new_number_of_hours = 2
      @booking = Booking.create_object( {
        :calendar_id => @calendar.id , 
        :title => "#{@customer.name} booking",
        :start_datetime => @start_datetime, 
        :number_of_hours => @new_number_of_hours ,
        :customer_id => @customer.id ,
        :is_downpayment_imposed => true
      })
    end
    
    it 'should create booking with new price' do
      expected_amount = 1*@specific_amount  + 1*@specific_amount
      @booking.amount.should == expected_amount
    end
  end
  
  context "overlapping price_rule: use the latest price rule" do
    before(:each) do
      @new_specific_amount = @specific_amount  *  2
  
      @new_price_rule = PriceRule.create_object(
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
                                    9, 30 , 0 
                ) .new_offset( Rational(0,24) )
      
      @new_number_of_hours = 2
      @booking = Booking.create_object( {
        :calendar_id => @calendar.id , 
        :title => "#{@customer.name} booking",
        :start_datetime => @start_datetime, 
        :number_of_hours => @new_number_of_hours ,
        :customer_id => @customer.id ,
        :is_downpayment_imposed => true
      })
    end
    
    it 'should use the latest price rule' do
      expected_amount = 1*@specific_amount  + 1*@specific_amount
      @booking.amount.should == expected_amount
    end
  end
  


end
