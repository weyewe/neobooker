require 'spec_helper'

describe Calendar do
  before(:each) do
    @calendar_amount = BigDecimal('200000')
    @downpayment_percentage = BigDecimal( '20')
    @calendar =  Calendar.create_object({
      :title => "Futsal 1",
      :color => 2 ,
      :amount => @calendar_amount,
      :downpayment_percentage => @downpayment_percentage
    })
  end
  
  it 'should create calendar' do
    @calendar.should be_valid 
  end
  
  it 'should create price rule' do
    PriceRule.count.should == 1 
  end
  
  context "price rule post-state" do
    before(:each) do
      @price_rule = PriceRule.first 
    end
    
    it 'should encompass all hours in a day' do
      @price_rule.hour_start.should == 0 
      @price_rule.hour_end.should == 23 
      
      
      @price_rule.is_sunday.should be_true  
      @price_rule.is_monday.should be_true      
      @price_rule.is_tuesday.should be_true     
      @price_rule.is_wednesday.should be_true   
      @price_rule.is_thursday.should be_true    
      @price_rule.is_friday.should be_true      
      @price_rule.is_saturday.should be_true 
      
      @price_rule.amount.should ==    @calendar_amount
      
      @price_rule.rule_case.should == PRICE_RULE_CASE[:catch_all]
      
      @price_rule.calendar_id.should == @calendar.id 
      @price_rule.is_active.should be_true 
    end
    
    
    
    
    
    context "update calendar (price unchanged, no booking) : should NOT delete the old price rule, create the new one" do
      before(:each) do
        @new_downpayment_percentage = @downpayment_percentage + BigDecimal('10')
        @calendar.update_object({
          :title => "Futsal 1",
          :color => 2 ,
          :amount => @calendar_amount,
          :downpayment_percentage => @new_downpayment_percentage
        })
        @price_rule.reload 
      end
      
      it 'should not delete the price_rule on calendar update if price UNCHANGED' do
        @price_rule.persisted?.should be_true 
        @calendar.downpayment_percentage.should == @new_downpayment_percentage
      end
    end
    
    context "update calendar (price changed, no booking) : should NOT delete the old price rule, create the new one" do
      before(:each) do
        @new_downpayment_percentage = @downpayment_percentage + BigDecimal('10')
        @new_calendar_amount = @calendar_amount + BigDecimal('50000')
        @calendar.update_object({
          :title => "Futsal 1",
          :color => 2 ,
          :amount => @new_calendar_amount,
          :downpayment_percentage => @new_downpayment_percentage
        })
        @price_rule.reload 
      end
      
      it 'should not delete the price_rule on calendar update if price UNCHANGED' do
        @price_rule.persisted?.should be_true 
        @calendar.downpayment_percentage.should == @new_downpayment_percentage
        @calendar.amount.should == @new_calendar_amount
      end
    end
    
    context "create initial booking for :update calendar (price changed, 1 affected booking)" do
      before(:each) do
        @number_of_hours = 2 
        @start_datetime =  DateTime.new( 2013, 9, 15, 
                                      17, 0 , 0 
                  ) .new_offset( Rational(0,24) )
                  
                  

        @customer = Customer.create_object({
          :name => "Andy"
          })
                  
        @booking = Booking.create_object( {
          :calendar_id => @calendar.id , 
          :title => "#{@customer.name} booking",
          :start_datetime => @start_datetime, 
          :number_of_hours => @number_of_hours ,
          :customer_id => @customer.id 
        })
        @price_rule = @calendar.catch_all_price_rule
      end
      
      it 'should have one price rule, catch all' do
        @price_rule.should be_valid 
      end
      
      it 'should create booking' do
        @booking.should be_valid
      end
      
      it 'should create price_details' do
        @booking.price_details.count.should == 1 
      end
      
      context "update the calendar price" do
        before(:each) do
          @new_calendar_amount = @calendar_amount + BigDecimal('50000')
          
          
          sleep 3
          @calendar.update_object(
            :title => "Futsal 1",
            :color => 2 ,
            :amount => @new_calendar_amount,
            :downpayment_percentage => @new_downpayment_percentage
          )
          @new_price_rule = @calendar.catch_all_price_rule
        end
        
        it 'should update the calendar' do
          @calendar.errors.size.should == 0
          @calendar.should be_valid 
        end
        
        it 'should create a new catch_all price_rule' do
          @price_rule.reload
          @price_rule.should be_valid
          @price_rule.is_active.should be_false 
          
          @new_price_rule.id.should_not == @price_rule.id 
        end
        
        it 'should deactivate the odl price rule' do
          @price_rule.reload 
          @price_rule.deactivated_at.should_not be_nil
          
          @price_rule.deactivated_at.should be > @booking.created_at 
        end
        
        
        
        context "update the booking" do
          before(:each) do
            
            # puts "\n\n=========== result"
            # puts "==========================>\n"*10
            @new_number_of_hours = @number_of_hours + 1 
            @booking.update_object(
              :calendar_id => @calendar.id , 
              :title => "#{@customer.name} latest",
              :start_datetime => @start_datetime, 
              :number_of_hours => @new_number_of_hours ,
              :customer_id => @customer.id
            )
            
            @booking.reload 
           
          end
          
                  
          
          it 'should still use the old price_rule' do
            @booking.errors.size.should == 0 
            @booking.price_details .count.should == 1 
            @first_price_detail = @booking.price_details.first
            
            @first_price_detail.price_rule_id.should == @price_rule.id 
          end
          
          it 'should update the amount' do
            @booking.amount.should == @new_number_of_hours * @calendar_amount
          end
        end
      end
      
    end
  end
end
