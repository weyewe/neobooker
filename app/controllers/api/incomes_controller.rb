class Api::IncomesController < Api::BaseApiController
  
  def index
    puts "The current user : #{current_user}"  
    # sleep 5
    
    # livesearch
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Income.joins(:customer,:calendar).where{
        (is_deleted.eq false) & 
        (
          (customer.name =~  livesearch ) | 
          (calendar.title =~ livesearch)
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Income.joins(:customer,:calendar).where{
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
      @objects = Income.active_objects.joins(:customer).bookings_in_between(startDate, endDate)
      @total = @objects.count 
    else
      @objects = Income.active_objects.joins(:customer, :calendar).page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Income.active_objects.count
    end
    
  end


  def income_reports
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
      bookings = Income.where{
        (transaction_datetime.gte starting_date) & 
        (transaction_datetime.lt ending_date )
      }
      
      
      
      
      (1..7).each do |diff|
         
        projected_start_datetime = starting_date + (diff-1).days 
        projected_end_datetime = starting_date + diff.days 
        
        name  = projected_start_datetime + UTC_OFFSET.hours
        record = {}
        record[:name] = "#{name.year}/#{name.month}/#{name.day}"
        
        record[:data1] = bookings.where{
          (transaction_datetime.gte projected_start_datetime) & 
          (transaction_datetime.lt projected_end_datetime )
        }.sum('amount')
        
        records << record 
      end
      
      
      
      
    elsif view_value == VIEW_VALUE[:month]
      starting_date = date - date.mday.days 
      
      days_in_month = Time.days_in_month(date.month, date.year)
      ending_date = starting_date + days_in_month.days
   
      bookings = Income.where{
        (transaction_datetime.gte starting_date) & 
        (transaction_datetime.lt ending_date )
      }
      
      
      
      (1..days_in_month).each do |diff|
         
        projected_start_datetime = starting_date + (diff-1).days 
        projected_end_datetime = starting_date + diff.days 
        
        name  = projected_start_datetime + UTC_OFFSET.hours
        record = {}
        record[:name] = "#{name.year}/#{name.month}/#{name.day}"
        
        record[:data1] = bookings.where{
          (transaction_datetime.gte projected_start_datetime) & 
          (transaction_datetime.lt projected_end_datetime )
        }.sum('amount')
        
        records << record 
      end
     
    end
    
    render :json => { :records => records , :total => records.count, :success => true }
  end
end
