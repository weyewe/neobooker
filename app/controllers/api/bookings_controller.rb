class Api::BookingsController < Api::BaseApiController
  
  def index
    puts "The current user : #{current_user}"  
    # sleep 5
    
    # livesearch
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Booking.joins(:customer,:calendar).where{
        (is_deleted.eq false) & 
        (
          (customer.name =~  livesearch ) | 
          (calendar.title =~ livesearch)
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Booking.joins(:customer,:calendar).where{
        (is_deleted.eq false) & 
        (
          (customer.name =~  livesearch ) | 
          (calendar.title =~ livesearch)
        )
      }.count
      
      # calendar 
    elsif params[:startDate].present? 
      startDate = extract_extensible_date( params[:startDate])
      endDate = ( extract_extensible_date(params[:endDate]) + 1.day ).to_date.to_datetime
      @objects = Booking.active_objects.joins(:customer).bookings_in_between(startDate, endDate)
      @total = @objects.count 
    else
      @objects = Booking.active_objects.joins(:customer, :calendar).page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Booking.active_objects.count
    end
    
  end

  def create
    
    params[:booking][:start_datetime] =  parse_datetime_from_client_booking( params[:booking][:start_datetime] )
    
    @object = Booking.create_object(params[:booking])
 
    if @object.errors.size  == 0
      render :json => { :success => true, 
                        :bookings => [
                            {
                              :id 						 =>	@object.id,                                               
                            	:start_datetime  =>	format_datetime_friendly(@object.start_datetime),
                            	:end_datetime 	 =>	format_datetime_friendly(@object.end_datetime)  ,
                            	:number_of_hours => @object.number_of_hours, 
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
      
      if @object.is_confirmed? 
        if not current_user.has_role?(:bookings , :post_confirm_update)
          puts "Doesn't have the role for post confirm delete"
          render :json => {:success => false, :access_denied => "Sudah Konfirmasi. Tidak bisa diganti kecuali oleh manager atau admin"}
          return 
        end
      end
      params[:booking][:start_datetime] =  parse_datetime_from_client_booking( params[:booking][:start_datetime] )
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
    puts "Gonna destroy "
    if @object.is_confirmed? 
      if not current_user.has_role?(:bookings , :post_confirm_delete)
        render :json => {:success => false, :access_denied => "Sudah Konfirmasi. Hanya dapat di hapus manager atau admin"}
        return 
      end
    end
    
    puts "it has the role for post confirm delete"
    
    @object.delete_object

    if (not @object.persisted? or @object.is_deleted? ) and @object.errors.size == 0 
      render :json => { :success => true, :total => Booking.active_objects.count }  
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
    
    if @object.errors.size == 0  and @object.is_confirmed?  and @object.is_paid? 
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

  def booking_reports
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
      bookings = Booking.active_objects.where{
        (start_datetime.gte starting_date) & 
        (start_datetime.lt ending_date )
      }
      
      
      
      
      (1..7).each do |diff|
         
        projected_start_datetime = starting_date + (diff-1).days 
        projected_end_datetime = starting_date + diff.days 
        
        name  = projected_start_datetime + UTC_OFFSET.hours
        record = {}
        record[:name] = "#{name.year}/#{name.month}/#{name.day}"
        
        record[:data1] = bookings.where{
          (start_datetime.gte projected_start_datetime) & 
          (start_datetime.lt projected_end_datetime )
        }.sum('number_of_hours')
        
        records << record 
      end
      
      
      
      
    elsif view_value == VIEW_VALUE[:month]
      starting_date = date - date.mday.days 
      
      days_in_month = Time.days_in_month(date.month, date.year)
      ending_date = starting_date + days_in_month.days
   
      bookings = Booking.active_objects.where{
        (start_datetime.gte starting_date) & 
        (start_datetime.lt ending_date )
      }
      
      
      
      (1..days_in_month).each do |diff|
         
        projected_start_datetime = starting_date + (diff-1).days 
        projected_end_datetime = starting_date + diff.days 
        
        name  = projected_start_datetime + UTC_OFFSET.hours
        record = {}
        record[:name] = "#{name.year}/#{name.month}/#{name.day}"
        
        record[:data1] = bookings.where{
          (start_datetime.gte projected_start_datetime) & 
          (start_datetime.lt projected_end_datetime )
        }.sum('number_of_hours')
        
        records << record 
      end
     
    end
    render :json => { :records => records , :total => records.count, :success => true }
  end

end
