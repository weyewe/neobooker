class Api::EventsController < Api::BaseApiController
  
  def index
    
      puts "This is the shite\n"*5
      
      # 2013-06-30
      startDate = extract_extensible_date( params[:startDate])
      endDate = ( extract_extensible_date(params[:endDate]) + 1.day ).to_date.to_datetime
      puts "The class : #{startDate.class.to_s}"
      puts "The startDate: #{startDate.year}, #{startDate.month}, #{startDate.day}"
      puts "The endDate : #{endDate.year}, #{endDate.month}, #{endDate.day}"
      
      puts "startDate: #{startDate}"
      puts "endDate : #{endDate}"
      puts "startDate.to_time : #{startDate.to_time.to_s}"
      puts "endDate.to_time : #{endDate.to_time.to_s}"
      
      @objects = current_office.bookings.active_objects.where(:is_salvaged => false).bookings_in_between(startDate, endDate)
      @total = @objects.count 
      puts "Total count: #{@total}"
      
     
  end
 
  
  def update 
    @object = current_office.bookings.find(params[:id])
    render :json => { :success => true,   
                      :bookings => [{
                        :id 						 =>	@object.id,                                               
                      	:start_datetime  =>	format_datetime(@object.start_datetime),
                      	:end_datetime 	 =>	format_datetime(@object.end_datetime)  ,
                      	:title 					 =>	@object.title,
                      	:calendar_id 		 =>	@object.calendar_id
                      }],
                      :total => current_office.bookings.active_objects.count  } 
  end
 
end
