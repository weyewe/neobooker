require 'spec_helper'

describe PriceRule do
  before(:each) do
    # Account.setup_business
    @current_office = Office.create_object :name => "OFfice1", :description => "balblalbalba", :code => "XXX"
    
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
    
    @number_of_hours = 2 
    @start_datetime =  DateTime.new( 2013, 9, 15, 
                                  8, 0 , 0 
              ) .new_offset( Rational(0,24) )
              # jakarta time = 8 + 7 == 15 
              
    
    @holiday_date = DateTime.new(2014, 7, 9,0,0,0)
    
    @new_amount = @calendar_amount + BigDecimal("200000")
    @holiday_price_rule = @current_office.price_rules.create_holiday_object(
      :is_sunday         => false ,
      :is_monday         => false ,
      :is_tuesday        => false ,
      :is_wednesday      => false ,
      :is_thursday       => false ,
      :is_friday         => true ,
      :is_saturday       => false ,
      :amount            => @new_amount   ,
      :rule_case         =>  PRICE_RULE_CASE[:holiday]    ,
      :calendar_id       => @calendar.id ,
      :hour_start => 17 , 
      :hour_end => 23 ,
      :is_holiday => true , 
      :holiday_date => @holiday_date
    )
    
    
    
  end
  
  it "should create booking" do
    @booking = @current_office.bookings.create_object( {
      :calendar_id => @calendar.id , 
      :title => "#{@customer.name} booking",
      :start_datetime => @holiday_date + 7.hours , 
      :number_of_hours => 1  ,
      :customer_id => @customer.id ,
      :is_downpayment_imposed => true 
    })
    
    @booking.errors.size.should ==0 
    @booking.should be_valid
  end
  
  it "should create valid holiday price rule" do
    @holiday_price_rule.reload 
    @holiday_price_rule.errors.size.should == 0 
    @holiday_price_rule.should be_valid
  end
  
  it "should assign finish date" do
    puts "Total error: #{@holiday_price_rule.errors.size}"
    puts "finish holiday date: #{@holiday_price_rule.finish_holiday_date}"
    @holiday_price_rule.errors.messages.each do |x|
      puts "ERror: #{x}"
    end
    @holiday_price_rule.finish_holiday_date.should_not be_nil
  end
  
  
  
  context "created booking" do
    before(:each) do
      @booking = @current_office.bookings.create_object( {
        :calendar_id => @calendar.id , 
        :title => "#{@customer.name} booking",
        :start_datetime => @holiday_date + 7.hours , 
        :number_of_hours => 1  ,
        :customer_id => @customer.id ,
        :is_downpayment_imposed => true 
      })
      @holiday_price_rule.reload 
    end
    
    it "should create holiday price rule's finish_holiday_date" do
      puts "start holiday date: #{@holiday_price_rule.holiday_date}"
      @holiday_price_rule.finish_holiday_date.should_not be_nil 
    end
    
    
    it "should select holiday price rule" do
      @booking.price_rules.count.should == 1 
      @booking.price_rules.first.should == @holiday_price_rule.id 
    end
  end
  
  context "create double holiday price rule on the same day" do
    before(:each) do
      @new_holiday_price_rule = @current_office.price_rules.create_holiday_object(
        :is_sunday         => false ,
        :is_monday         => false ,
        :is_tuesday        => false ,
        :is_wednesday      => false ,
        :is_thursday       => false ,
        :is_friday         => true ,
        :is_saturday       => false ,
        :amount            => @new_amount   ,
        :rule_case         =>  PRICE_RULE_CASE[:holiday]    ,
        :calendar_id       => @calendar.id ,
        :hour_start => 17 , 
        :hour_end => 23 ,
        :is_holiday => true , 
        :holiday_date => @holiday_date
      )
      
      @booking = @current_office.bookings.create_object( {
        :calendar_id => @calendar.id , 
        :title => "#{@customer.name} booking",
        :start_datetime => @holiday_date + 9.hours , 
        :number_of_hours => 1  ,
        :customer_id => @customer.id ,
        :is_downpayment_imposed => true 
      })
    end 
    
    it "should create holiday price rule's finish_holiday_date" do 
      @new_holiday_price_rule.finish_holiday_date.should_not be_nil 
    end
    
    
    it "should select holiday price rule" do
      @booking.price_rules.count.should == 1 
      @booking.price_rules.first.should == @new_holiday_price_rule.id 
    end
  end
   
     
end
