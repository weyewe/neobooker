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
    
    
    @holiday_amount = 3*@specific_amount 
    # 9 April 2014, Wednesday
    @holiday_date  = DateTime.new(2014, 
                              4, 
                              9, 
                               0, 
                               0, 
                               0,
                  Rational( UTC_OFFSET , 24) ).utc
                  
  
    @start_datetime = @holiday_date + 9.hours
    
    
    @holiday_price_rule = @current_office.price_rules.create_holiday_object(
      :holiday_date => @holiday_date, 
      :amount            => @holiday_amount     , 
      :calendar_id       => @calendar.id , 
    )


    @booking = @current_office.bookings.create_object( {
      :calendar_id => @calendar.id , 
      :title => "#{@customer.name} booking",
      :start_datetime => @start_datetime, 
      :number_of_hours => @number_of_hours ,
      :customer_id => @customer.id ,
      :is_downpayment_imposed => true
      })
    
    @current_office.reload
  end
  
  it "should assign specific price rule to office" do
    @specific_price_rule.office_id.should == @current_office.id 
  end
  
  it "should create holiday price rule" do
    @holiday_price_rule.errors.size.should == 0 
    @holiday_price_rule.office_id.should == @current_office.id
  end
  
  it 'should create 3 pric rule' do
    @current_office.price_rules.count.should == 3 
  end
  
  it 'should select the holiday price rule' do
    @booking.errors.messages.each {|x| puts x }
    @booking.should be_valid
    price_rule_id_list = @booking.price_details.map{|x| x.price_rule_id}
    price_rule_id_list.uniq!
    price_rule_id_list.count.should == 1 
    price_rule_id_list.first.should == @holiday_price_rule.id
  end
   
       
end
