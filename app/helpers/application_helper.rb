module ApplicationHelper
  
  def format_datetime( datetime ) 
    return nil if datetime.nil? 
    
    a = datetime.in_time_zone("Jakarta")
    
    # object.start_datetime.to_datetime.new_offset( Rational(7,24) ) .to_time.iso8601
    return a.to_time.iso8601 
  end
  
  def format_datetime_friendly( datetime ) 
    return nil if datetime.nil? 
     
    
    a = datetime.in_time_zone("Jakarta")
    day = a.day
    month = a.month
    year = a.year
    hour = a.hour
    minute = a.min
    second = a.sec 
    
    if day.to_s.length == 1 
      day = "0#{day}"
    end
    
    if month.to_s.length == 1 
      month = "0#{month}"
    end
    
    if hour.to_s.length == 1
      hour  = "0#{hour}"
    end
    
    if minute.to_s.length == 1 
      minute = "0#{minute}"
    end
    
    if second.to_s.length == 1 
      second = "0#{second}"
    end
    
    return "#{day}-#{month}-#{year}" + " " + 
            "#{hour}:#{minute}:#{second}"
  end
  
end
