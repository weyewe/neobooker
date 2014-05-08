require 'spec_helper'

describe PriceRule do
  before(:each) do
    Account.setup_business
    @calendar_amount = BigDecimal('200000')
    @downpayment_percentage = BigDecimal( '20')
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
    
    
    @holiday_price_rule = PriceRule.create_holiday_object(
      :holiday_date => @holiday_date, 
      :amount            => @holiday_amount     , 
      :calendar_id       => @calendar.id , 
    )


    @booking = Booking.create_object( {
      :calendar_id => @calendar.id , 
      :title => "#{@customer.name} booking",
      :start_datetime => @start_datetime, 
      :number_of_hours => @number_of_hours ,
      :customer_id => @customer.id ,
      :is_downpayment_imposed => true
      })
    
  end
  
  it 'should create 3 pric rule' do
    PriceRule.count.should == 3 
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
