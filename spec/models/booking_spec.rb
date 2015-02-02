require 'spec_helper'

describe Booking do
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
  end
  
  it 'should create calendar' do
    @calendar.should be_valid 
  end
  
  it 'should create customer' do
    @customer.should be_valid 
  end
  
  it 'should create 1 PriceRule' do
    @current_office.price_rules.count.should == 1 
  end
  
  it 'should not have PriceDetail' do
    @current_office.price_details.count.should ==  0 
  end
  
  context "create booking" do
    before(:each) do 
      
      @number_of_hours = 2 
      @start_datetime =  DateTime.new( 2013, 9, 15, 
                                    8, 0 , 0 
                ) .new_offset( Rational(0,24) )
                # jakarta time = 8 + 7 == 15 
                
      @booking = @current_office.bookings.create_object( {
        :calendar_id => @calendar.id , 
        :title => "#{@customer.name} booking",
        :start_datetime => @start_datetime, 
        :number_of_hours => @number_of_hours ,
        :customer_id => @customer.id ,
        :is_downpayment_imposed => true 
      })
      
      @price_detail = @current_office.price_details.first 
      @booking.errors.messages.each {|x| puts x }
      @booking.reload 
    end
    
    it 'should create booking' do
      @booking.should be_valid 
    end
    
    it 'should create 1 price details' do
      
      # puts "\n\nGonnnnaa inspect the booking\n"
      @booking.price_details.count.should == 1 
      @price_detail.should be_valid 
    end
    
    context "update booking, no changes in start_datetime or number_of_hours" do
      before(:each) do
        @booking.update_object(
          :calendar_id => @calendar.id , 
          :title => "#{@customer.name} latest",
          :start_datetime => @start_datetime, 
          :number_of_hours => @number_of_hours ,
          :customer_id => @customer.id,
          :is_downpayment_imposed => true
        )
        @booking.reload 
      end
      
      it 'should be_valid' do
        @booking.should be_valid
      end
      
      it 'should not update price detail' do
        @booking.price_details.count.should == 1 
        @new_price_detail = @booking.price_details.first 
        @new_price_detail.id.should == @price_detail.id 
      end
    end
    
    context "update booking, changes in start_datetime or number of hours" do
      before(:each) do
        @new_number_of_hours = @number_of_hours + 1 
        @booking.update_object({
          :calendar_id => @calendar.id , 
          :title => "#{@customer.name} latest",
          :start_datetime => @start_datetime, 
          :number_of_hours => @new_number_of_hours ,
          :customer_id => @customer.id,
          :is_downpayment_imposed => true
        })
        @booking.reload 
        
        # @price_detail.reload 
      end
      
      it 'should produce one price detail' do
        @booking.price_details.count.should == 1 
      end
      
      it 'should delete the initial price detail' do
        @new_price_detail = @booking.price_details.first 
        @new_price_detail.id.should_not == @price_detail.id 
      end
    end
    
    context "destroy booking" do
      before(:each) do
        @price_detail_array = @booking.price_details 
        @booking.destroy 
      end
      
      it 'should destroy booking' do
        @current_office.bookings.find_by_id(@booking.id).should be_nil 
      end
      
      it 'should destroy price booking' do
        @price_detail_array.each do |price_detail|
          @current_office.price_details.find_by_id( price_detail.id).should be_nil 
        end
      end
    end
    
    
  end
end
