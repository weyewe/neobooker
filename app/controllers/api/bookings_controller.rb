class Api::BookingsController < Api::BaseApiController
  
  def index
    puts "The current user : #{current_user}"  
    # sleep 5
    
    # livesearch
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Booking.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch )
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Booking.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch )
        )
      }.count
      
      # calendar 
    elsif params[:startDate].present? 
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
      
      @objects = Booking.joins(:customer).bookings_in_between(startDate, endDate)
      @total = @objects.count 
      puts "Total count: #{@total}"
      
      # the base grid 
    else
      @objects = Booking.joins(:customer, :calendar).active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Booking.active_objects.count
    end
    
    # render :json => { :bookings => @objects , :total => @total , :success => true }
  end

  def create
    
    # parse_datetime_from_client
    
    puts "\nThe start_datetime ********"
    params[:booking][:start_datetime] =  parse_datetime_from_client( params[:booking][:start_datetime] )
    
    puts "\nThe end_datetime ********"
    params[:booking][:end_datetime] =  parse_datetime_from_client( params[:booking][:end_datetime] )
    @object = Booking.create_object(params[:booking])
 
    if @object.errors.size  == 0
      render :json => { :success => true, 
                        :bookings => [
                            {
                              :id 						 =>	@object.id,                                               
                            	:start_datetime  =>	@object.start_datetime.to_datetime.new_offset( Rational(7,24) ) .to_time.iso8601,
                            	:end_datetime 	 =>	@object.end_datetime.to_datetime.new_offset( Rational(7,24) ) .to_time.iso8601,
                            	:title 					 =>	@object.title,
                            	:calendar_id 		 =>	@object.calendar_id
                            }
                          ] , 
                        :total => Booking.active_objects.count }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg                         
    end
  end
  
  def show
    @object  = Booking.find params[:id]
    render :json => { :success => true,   
                      :booking => {
                        :id 						 =>	@object.id,                                               
                      	:start_datetime  =>	format_datetime(@object.start_datetime),
                      	:end_datetime 	 =>	format_datetime(@object.end_datetime)  ,
                      	:title 					 =>	@object.title,
                      	:calendar_id 		 =>	@object.calendar_id
                      },
                      :total => Booking.active_objects.count  }
  end

  def update
    @object = Booking.find(params[:id])
    
    params[:booking][:start_datetime] =  parse_datetime_from_client( params[:booking][:start_datetime] )
    params[:booking][:end_datetime] =  parse_datetime_from_client( params[:booking][:end_datetime] )
    
    
    if @object.update_object(params[:booking])
      render :json => { :success => true,   
                        :bookings => [{
                          :id 						 =>	@object.id,                                               
                        	:start_datetime  =>	format_datetime(@object.start_datetime),
                        	:end_datetime 	 =>	format_datetime(@object.end_datetime)  ,
                        	:title 					 =>	@object.title,
                        	:calendar_id 		 =>	@object.calendar_id
                        }],
                        :total => Booking.active_objects.count  } 
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg 
    end
  end

  def destroy
    @object = Booking.find(params[:id])
    @object.delete_object

    if @object.is_deleted
      render :json => { :success => true, :total => Booking.active_objects.count }  
    else
      render :json => { :success => false, :total => Booking.active_objects.count }  
    end
  end
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?  
      @objects = Booking.where{  (name =~ query)   & 
                                (is_deleted.eq false )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    else
      @objects = Booking.where{ (id.eq selected_id)  & 
                                (is_deleted.eq false )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    end
    
    
    render :json => { :records => @objects , :total => @objects.count, :success => true }
  end
end
