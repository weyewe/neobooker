class Api::IncomesController < Api::BaseApiController
  
  


  def index
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
        projected_end_datetime = starting_date + diff.days 
        
        name  = projected_start_datetime + UTC_OFFSET.hours
        record = {}
        record[:name] = "#{name.year}/#{name.month}/#{name.day}"
        
        record[:data1] = bookings.where{
          (start_datetime.gte projected_start_datetime) & 
          (end_datetime.lt projected_end_datetime )
        }.sum('amount')
        
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
        projected_end_datetime = starting_date + diff.days 
        
        name  = projected_start_datetime + UTC_OFFSET.hours
        record = {}
        record[:name] = "#{name.year}/#{name.month}/#{name.day}"
        
        record[:data1] = bookings.where{
          (start_datetime.gte projected_start_datetime) & 
          (end_datetime.lt projected_end_datetime )
        }.sum('amount')
        
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
