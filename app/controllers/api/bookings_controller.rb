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
    params[:booking][:start_datetime] =  parse_datetime_from_client_booking( params[:booking][:start_datetime] )
    
    puts "\nThe end_datetime ********"
    params[:booking][:end_datetime] =  parse_datetime_from_client_booking( params[:booking][:end_datetime] )
    @object = Booking.create_object(params[:booking])
 
    if @object.errors.size  == 0
      render :json => { :success => true, 
                        :bookings => [
                            {
                              :id 						 =>	@object.id,                                               
                            	:start_datetime  =>	format_datetime_friendly(@object.start_datetime),
                            	:end_datetime 	 =>	format_datetime_friendly(@object.end_datetime)  ,
                            	:number_of_hours => number_of_hours, 
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
                      	:start_datetime  =>	format_datetime_friendly(@object.start_datetime),
                      	:end_datetime 	 =>	format_datetime_friendly(@object.end_datetime)  ,
                      	:number_of_hours => @object.number_of_hours, 
                      	:title 					 =>	@object.title,
                      	:calendar_id 		 =>	@object.calendar_id
                      },
                      :total => Booking.active_objects.count  }
  end

  def update
    @object = Booking.find(params[:id])
    
    if params[:update_actual_start_datetime].present?  
      params[:booking][:actual_start_datetime] =  parse_datetime_from_client_booking( params[:booking][:actual_start_datetime] )
      @object.update_actual_start_datetime(   params[:booking][:actual_start_datetime] )
    elsif params[:update_actual_end_datetime].present?
      params[:booking][:actual_end_datetime] =  parse_datetime_from_client_booking( params[:booking][:actual_end_datetime] ) 
      @object.update_actual_end_datetime(   params[:booking][:actual_end_datetime ] )
    else
      params[:booking][:start_datetime] =  parse_datetime_from_client_booking( params[:booking][:start_datetime] )
      params[:booking][:end_datetime] =  parse_datetime_from_client_booking( params[:booking][:end_datetime] )
      @object.update_object(params[:booking])
    end
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :bookings => [{
                          :id 						 =>	@object.id,                                               
                        	:start_datetime  =>	format_datetime_friendly(@object.start_datetime),
                        	:end_datetime 	 =>	format_datetime_friendly(@object.end_datetime)  ,
                        	:number_of_hours => @object.number_of_hours, 
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

    if not @object.persisted? or @object.is_deleted?
      render :json => { :success => true, :total => Booking.active_objects.count }  
    else
      render :json => { :success => false, :total => Booking.active_objects.count }  
    end
  end
  
  
=begin
  Business Process 
=end
  def confirm
    @object = Booking.find_by_id params[:id]
    # add some defensive programming.. current user has role admin, and current_user is indeed belongs to the company 
    @object.confirm   
    
    if @object.errors.size == 0  and @object.is_confirmed? 
      render :json => { :success => true, :total => Booking.active_objects.count }  
    else
      # render :json => { :success => false, :total => Delivery.active_objects.count } 
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg 
    end
  end
  
  
  
  def pay
    @object = Booking.find_by_id params[:id]
    # add some defensive programming.. current user has role admin, and current_user is indeed belongs to the company 
    @object.pay   
    
    if @object.errors.size == 0  and @object.is_confirmed? 
      render :json => { :success => true, :total => Booking.active_objects.count }  
    else
      # render :json => { :success => false, :total => Delivery.active_objects.count } 
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg 
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
  
  
=begin
  FOR REPORTING PURPOSES 
=end


  def sales_amount_reports
    if params[:viewValue].nil? or params[:focusDate].nil?
      render :json => { :error => "Invalid params"}
      return 
    end
    
    
    view_value = params[:viewValue].to_i  
    date = parse_datetime_from_client_booking( params[:focusDate])
    date =   DateTime.new( date.year , 
                              date.month, 
                              date.day, 
                              0, 
                              0, 
                              0,
                  Rational( UTC_OFFSET , 24) )
                  
    
    
    # SOP; 1 SQL query.. use ruby code to distribute the data..
    # for 1 year query, it is gonna be a big sQL query. hahaha. banzai 
    # display logic can be done in the client. but, fuck it . 
    
    records = [] 
    if view_value == VIEW_VALUE[:week]
      starting_date = date - date.wday.days 
      ending_date = starting_date + 7.days 
      bookings = Booking.where{
        (start_datetime.gte starting_date) & 
        (end_datetime.lt ending_date )
      }
      
      
      
      (1..7).each do |diff|
         
        projected_start_datetime = starting_date + (diff-1).days 
        projected_end_datetime = ending_date + diff.days 
        
        name  = projected_start_datetime + UTC_OFFSET.hours
        record = {}
        record[:name] = "#{name.year}/#{name.month}/#{name.day}"
        
        record[:data1] = bookings.where{
          (start_datetime.gte projected_start_datetime) & 
          (end_datetime.lt projected_end_datetime )
        }.sum('received_amount')
        
        records << record 
      end
      
      
      
      
    elsif view_value == VIEW_VALUE[:month]
      starting_date = date - date.mday.days 
      
      days_in_month = Time.days_in_month(date.month, date.year)
      ending_date = starting_date + days_in_month.days
   
      bookings = Booking.where{
        (start_datetime.gte starting_date) & 
        (end_datetime.lt ending_date )
      }
      
      
      
      (1..days_in_month).each do |diff|
         
        projected_start_datetime = starting_date + (diff-1).days 
        projected_end_datetime = ending_date + diff.days 
        
        name  = projected_start_datetime + UTC_OFFSET.hours
        record = {}
        record[:name] = "#{name.year}/#{name.month}/#{name.day}"
        
        record[:data1] = bookings.where{
          (start_datetime.gte projected_start_datetime) & 
          (end_datetime.lt projected_end_datetime )
        }.sum('received_amount')
        
        records << record 
      end
      
      
    elsif view_value == VIEW_VALUE[:year]
      starting_date = date - date.mday.days 
      
      days_in_month = Time.days_in_month(date.month, date.year)
      ending_date = starting_date + days_in_month.days
   
      bookings = Booking.where{
        (start_datetime.gte starting_date) & 
        (end_datetime.lt ending_date )
      }
      
      
      
      (1..days_in_month).each do |diff|
         
        projected_start_datetime = starting_date + (diff-1).days 
        projected_end_datetime = ending_date + diff.days 
        
        name  = projected_start_datetime + UTC_OFFSET.hours
        record = {}
        record[:name] = "#{name.year}/#{name.month}/#{name.day}"
        
        record[:data1] = bookings.where{
          (start_datetime.gte projected_start_datetime) & 
          (end_datetime.lt projected_end_datetime )
        }.sum('received_amount')
        
        records << record 
      end
      
    end
  
    
    render :json => { :records => records , :total => records.count, :success => true }
  end
  
=begin
  Sunday is the day 0 of the week 
  
  now = DateTime.now => if today is Tuesday , 
  now.wday # => will produce 2 .. means 2 days from sunday.. how can we get the first sunday?
  sunday = now - now.wday.days  => will give the sunday. 
  next_sunday = sunday + 7.days    => will produce next sunday, 1 second before sunday 
  
  get all bookings between today and next sunday 
  sunday <= bookings <= next_sunday 
    
=end
end
