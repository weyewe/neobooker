class Api::IncomesController < Api::BaseApiController
  
  def index
    puts "The current user : #{current_user}"  
    # sleep 5
    
    # livesearch
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = current_office.incomes.where{
        (is_deleted.eq false) & 
        (
          (customer.name =~  livesearch ) | 
          (calendar.title =~ livesearch)
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = current_office.incomes.where{
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
      @objects = current_office.incomes.incomes_in_between(startDate, endDate)
      @total = @objects.count 
    elsif params[:focusDate].present? 
      
=begin
now.beginning_of_day     now.beginning_of_month   now.beginning_of_year   
now.beginning_of_hour    now.beginning_of_quarter
now.beginning_of_minute  now.beginning_of_week
=end
      startDate = extract_extensible_date( params[:focusDate])
      startDate = startDate.to_datetime
      puts "The focus date: #{params[:focusDate]}"
      puts "The start_date :#{startDate}"
      # startDate = startDate.to_date.to_datetime + 7.hours
      endDate = startDate.to_date.to_datetime + 24.hours
      
      if params[:viewValue].to_i == VIEW_VALUE[:month]
        endDate = startDate.to_date.to_datetime + 1.week
      end
      
       #( startDate + 24.hours).to_date.to_datetime
      puts "The end_date = #{endDate}"
      @objects = current_office.incomes.incomes_in_between(startDate, endDate)
      @total = @objects.count
    else
      @objects = current_office.incomes.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = current_office.incomes.count
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
      bookings = current_office.incomes.where{
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
   
      bookings = current_office.incomes.where{
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
